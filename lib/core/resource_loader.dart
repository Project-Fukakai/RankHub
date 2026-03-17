import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/data_definition.dart';
import 'package:rank_hub/core/game_resource.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/core/resource_scope.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/core/services/resource_cache_service.dart';
import 'package:rank_hub/platforms/platform_registry.dart';

class ResourceLoader {
  final ResourceRegistry registry;
  final ResourceScope scope;
  final List<PlatformAdapter> adapters;
  final Account? account;
  final PlatformRegistry platformRegistry;

  final Map<ResourceKey, ResourceState> _state = {};
  final Map<ResourceKey, Future> _inflight = {};
  final Set<ResourceKey> _loadingStack = {}; // 用于检测循环依赖

  ResourceLoader({
    required this.registry,
    required this.scope,
    required this.adapters,
    this.account,
    required this.platformRegistry,
  });

  /// 强制加载（如果未加载或已过期）
  /// 如果数据已加载且未过期，直接返回缓存数据
  Future<T> load<T>(ResourceKey key) async {
    var allowCache = true;
    // 已有数据
    final existing = _state[key];
    if (existing is AsyncData<T>) {
      // 检查是否过期（使用数据库）
      final isExpired = await _isExpired(key);
      if (!isExpired) {
        return existing.value;
      }
      // 已过期，需要重新加载
      allowCache = false;
    }

    // 已在加载中
    if (_inflight.containsKey(key)) {
      return await _inflight[key] as T;
    }

    // 检测循环依赖（允许等待已在加载中的依赖）
    if (_loadingStack.contains(key)) {
      throw Exception(
        'Circular dependency detected: ${_buildDependencyChain(key)}',
      );
    }

    final def = registry.find<T>(key);
    if (def == null) {
      throw Exception('No resource registered for $key');
    }

    // 加入加载栈
    _loadingStack.add(key);

    try {
      // 先加载依赖
      await _loadDependencies(def.dependencies);

      final future = _doLoad<T>(key, def, allowCache: allowCache);
      _inflight[key] = future;

      try {
        final result = await future;
        return result;
      } finally {
        _inflight.remove(key);
      }
    } finally {
      _loadingStack.remove(key);
    }
  }

  /// 尝试读取（不触发 fetch）
  Future<T?> tryLoad<T>(ResourceKey key) async {
    final state = _state[key];
    if (state is AsyncData<T>) {
      // 检查是否过期（使用数据库）
      final isExpired = await _isExpired(key);
      if (!isExpired) {
        return state.value;
      }
    }
    return null;
  }

  /// 强制刷新资源（忽略缓存和 TTL）
  /// 会清除现有缓存并重新从远端拉取
  Future<T> forceRefresh<T>(ResourceKey key) async {
    // 清除现有状态
    _state.remove(key);

    // 清除数据库缓存记录
    await _clearCacheRecord(key);

    // 如果正在加载中，等待完成后再清除
    if (_inflight.containsKey(key)) {
      try {
        await _inflight[key];
      } catch (_) {
        // 忽略错误，继续刷新
      }
      _inflight.remove(key);
    }

    // 重新加载
    return load<T>(key);
  }

  /// 批量加载多个资源（按照 DAG 拓扑排序）
  /// 返回 Map，键为 ResourceKey，值为加载结果
  Future<Map<ResourceKey, dynamic>> loadMultiple(List<ResourceKey> keys) async {
    final sorted = _topologicalSort(keys);
    final results = <ResourceKey, dynamic>{};

    for (final key in sorted) {
      try {
        final result = await load(key);
        results[key] = result;
      } catch (e) {
        // 继续加载其他资源，但记录错误
        results[key] = e;
      }
    }

    return results;
  }

  /// 加载依赖资源
  Future<void> _loadDependencies(List<ResourceKey> dependencies) async {
    if (dependencies.isEmpty) return;

    // 并行加载所有依赖
    await Future.wait(dependencies.map((dep) => load(dep)));
  }

  /// 拓扑排序（Kahn 算法）
  List<ResourceKey> _topologicalSort(List<ResourceKey> keys) {
    final inDegree = <ResourceKey, int>{};
    final graph = <ResourceKey, List<ResourceKey>>{};
    final allKeys = <ResourceKey>{};

    // 构建图和计算入度
    void buildGraph(ResourceKey key) {
      if (allKeys.contains(key)) return;
      allKeys.add(key);

      final def = registry.find(key);
      if (def == null) return;

      inDegree.putIfAbsent(key, () => 0);
      graph.putIfAbsent(key, () => []);

      for (final dep in def.dependencies) {
        buildGraph(dep);
        graph.putIfAbsent(dep, () => []).add(key);
        inDegree[key] = (inDegree[key] ?? 0) + 1;
      }
    }

    for (final key in keys) {
      buildGraph(key);
    }

    // Kahn 算法
    final queue = <ResourceKey>[];
    final result = <ResourceKey>[];

    // 找到所有入度为 0 的节点
    for (final entry in inDegree.entries) {
      if (entry.value == 0) {
        queue.add(entry.key);
      }
    }

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      result.add(current);

      for (final neighbor in graph[current] ?? []) {
        inDegree[neighbor] = (inDegree[neighbor] ?? 0) - 1;
        if (inDegree[neighbor] == 0) {
          queue.add(neighbor);
        }
      }
    }

    // 检测循环依赖
    if (result.length != allKeys.length) {
      throw Exception('Circular dependency detected in resource graph');
    }

    return result;
  }

  /// 构建依赖链字符串（用于错误提示）
  String _buildDependencyChain(ResourceKey key) {
    final chain = _loadingStack.toList()..add(key);
    return chain.map((k) => k.fullKey).join(' -> ');
  }

  /// 检查资源是否过期
  Future<bool> _isExpired(ResourceKey key) async {
    final def = registry.find(key);
    if (def == null) {
      return true;
    }

    final ttl = def.ttl;
    if (ttl == null) {
      return false; // 没有 TTL，永不过期
    }

    if (!scope.hasAccount) {
      return false; // 游客模式不做过期检查，避免反复远端拉取
    }

    // 从数据库检查过期状态
    try {
      final isExpired = await ResourceCacheService.instance.isExpired(
        resourceKey: key,
        platformId: scope.platformId.value,
        accountIdentifier: scope.accountIdentifier!,
      );
      return isExpired;
    } catch (e) {
      CoreLogService.w('检查资源过期状态失败: $e');
      return true; // 出错时认为已过期
    }
  }

  /// 记录资源加载时间到数据库
  Future<void> _recordLoadTime(ResourceKey key) async {
    final def = registry.find(key);
    if (def == null) return;

    final ttl = def.ttl;
    if (ttl == null) return; // 没有 TTL 的资源不记录

    if (!scope.hasAccount) return; // 没有账号，不记录

    try {
      await ResourceCacheService.instance.recordLoad(
        resourceKey: key,
        platformId: scope.platformId.value,
        accountIdentifier: scope.accountIdentifier!,
        ttlSeconds: ttl.inSeconds,
        isAccountRelated: def.accountRelated,
      );
    } catch (e) {
      CoreLogService.w('记录资源加载时间失败: $e');
    }
  }

  /// 清除指定资源的缓存记录
  Future<void> _clearCacheRecord(ResourceKey key) async {
    if (!scope.hasAccount) return;

    try {
      await ResourceCacheService.instance.clearCache(
        resourceKey: key,
        platformId: scope.platformId.value,
        accountIdentifier: scope.accountIdentifier!,
      );
    } catch (e) {
      CoreLogService.w('清除资源缓存记录失败: $e');
    }
  }

  /// 内部加载逻辑
  Future<T> _doLoad<T>(
    ResourceKey key,
    GameResourceDefinition<T> def, {
    required bool allowCache,
  }) async {
    _state[key] = const AsyncLoading();

    try {
      if (allowCache && !def.forceRefreshWhenTriggered) {
        // 本地缓存
        final cached = await def.loadCache(scope, account);
        if (cached != null) {
          _state[key] = AsyncData(cached);
          await _recordLoadTime(key); // 记录加载时间
          return cached;
        }
      }

      final resolvedAdapters = _resolveAdaptersForResource(def, key);

      // 远端拉取（只传递 scope 和 adapters）
      final data = await def.fetch(key, scope, resolvedAdapters, account);

      // 持久化
      await def.persist(data);

      _state[key] = AsyncData(data);
      await _recordLoadTime(key); // 记录加载时间
      return data;
    } catch (e, st) {
      _state[key] = AsyncError(e, st);
      rethrow;
    }
  }

  List<PlatformAdapter> _resolveAdaptersForResource(
    GameResourceDefinition def,
    ResourceKey key,
  ) {
    final platforms = platformRegistry.getPlatformsForResource(
      scope.gameId,
      key,
    );

    if (def.accountRelated) {
      if (account == null) {
        throw Exception('Account required for resource: ${key.fullKey}');
      }
      final isSupported = platforms.any(
        (platform) => platform.id.value == account!.platformId,
      );
      if (!isSupported) {
        throw Exception(
          'Account platform cannot provide resource: ${key.fullKey}',
        );
      }
    }

    final resolved = platformRegistry.resolveAdaptersForResource(
      gameId: scope.gameId,
      key: key,
      accountRelated: def.accountRelated,
      accountPlatformId: account?.platformId,
    );

    if (def.accountRelated) {
      return resolved;
    }

    return resolved.isEmpty ? adapters : resolved;
  }

  /// 给 UI / Provider 监听
  ResourceState<T> watch<T>(ResourceKey key) {
    return (_state[key] as ResourceState<T>?) ?? const AsyncLoading();
  }
}
