import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rank_hub/core/models/resource_cache_entity.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/core/services/core_log_service.dart';

/// 资源缓存服务
/// 使用 Isar 数据库记录资源的加载时间和过期时间
/// 启动时将所有缓存数据加载到内存，变更时异步写入数据库
class ResourceCacheService {
  static ResourceCacheService? _instance;
  static ResourceCacheService get instance {
    _instance ??= ResourceCacheService._();
    return _instance!;
  }

  ResourceCacheService._();

  Isar? _isar;
  bool _initialized = false;

  /// 内存缓存：resourceKey + accountKey -> ResourceCacheEntity
  final Map<String, ResourceCacheEntity> _memoryCache = {};

  /// 生成内存缓存的 key
  String _makeMemoryCacheKey(String resourceKey, String accountKey) {
    return '$resourceKey|$accountKey';
  }

  /// 初始化服务
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [ResourceCacheEntitySchema],
        directory: dir.path,
        name: 'core_resource_cache',
      );

      // 将所有缓存数据加载到内存
      await _loadAllToMemory();

      _initialized = true;
      CoreLogService.i(
        '资源缓存服务初始化完成，已加载 ${_memoryCache.length} 条缓存记录',
      );
    } catch (e) {
      CoreLogService.e('资源缓存服务初始化失败: $e');
      rethrow;
    }
  }

  /// 将所有缓存数据加载到内存
  Future<void> _loadAllToMemory() async {
    if (_isar == null) return;

    final allEntities = await _isar!.resourceCacheEntitys.where().findAll();

    _memoryCache.clear();
    for (final entity in allEntities) {
      final key = _makeMemoryCacheKey(entity.resourceKey, entity.accountKey);
      _memoryCache[key] = entity;
    }
  }

  void _ensureInitialized() {
    if (!_initialized || _isar == null) {
      throw StateError('ResourceCacheService 未初始化，请先调用 initialize()');
    }
  }

  /// 生成账号 key
  String _makeAccountKey(String platformId, String accountIdentifier) {
    return '$platformId:$accountIdentifier';
  }

  /// 记录资源加载
  Future<void> recordLoad({
    required ResourceKey resourceKey,
    required String platformId,
    required String accountIdentifier,
    required int ttlSeconds,
    required bool isAccountRelated,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);
    final fullKey = resourceKey.fullKey;
    final memoryCacheKey = _makeMemoryCacheKey(fullKey, accountKey);

    // 从内存中查找现有记录
    final existing = _memoryCache[memoryCacheKey];

    if (existing != null) {
      // 更新现有记录
      existing.updateLoadTime(ttlSeconds);
      existing.isAccountRelated = isAccountRelated;
    } else {
      // 创建新记录
      final entity = ResourceCacheEntity.create(
        resourceKey: fullKey,
        accountKey: accountKey,
        namespace: resourceKey.namespace,
        name: resourceKey.name,
        scope: resourceKey.scope,
        ttlSeconds: ttlSeconds,
        isAccountRelated: isAccountRelated,
      );
      _memoryCache[memoryCacheKey] = entity;
    }

    // 异步写入数据库
    _asyncWriteToDb(fullKey, accountKey);
  }

  /// 异步写入数据库
  void _asyncWriteToDb(String resourceKey, String accountKey) {
    final memoryCacheKey = _makeMemoryCacheKey(resourceKey, accountKey);
    final entity = _memoryCache[memoryCacheKey];

    if (entity == null) return;

    // 异步写入，不等待完成
    Future.microtask(() async {
      try {
        await _isar!.writeTxn(() async {
          // 查找数据库中的现有记录
          final existing = await _isar!.resourceCacheEntitys
              .filter()
              .resourceKeyEqualTo(resourceKey)
              .accountKeyEqualTo(accountKey)
              .findFirst();

          if (existing != null) {
            // 更新现有记录的 id，保持数据库主键不变
            entity.id = existing.id;
          }

          await _isar!.resourceCacheEntitys.put(entity);
        });
      } catch (e) {
        CoreLogService.w('异步写入资源缓存失败: $e');
      }
    });
  }

  /// 检查资源是否已过期
  Future<bool> isExpired({
    required ResourceKey resourceKey,
    required String platformId,
    required String accountIdentifier,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);
    final fullKey = resourceKey.fullKey;
    final memoryCacheKey = _makeMemoryCacheKey(fullKey, accountKey);

    // 从内存中读取
    final entity = _memoryCache[memoryCacheKey];

    if (entity == null) {
      // 没有记录，认为已过期
      return true;
    }

    return entity.isExpired;
  }

  /// 获取资源的加载时间
  Future<DateTime?> getLoadTime({
    required ResourceKey resourceKey,
    required String platformId,
    required String accountIdentifier,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);
    final fullKey = resourceKey.fullKey;
    final memoryCacheKey = _makeMemoryCacheKey(fullKey, accountKey);

    // 从内存中读取
    final entity = _memoryCache[memoryCacheKey];
    return entity?.lastLoadTime;
  }

  /// 清除指定资源的缓存记录
  Future<void> clearCache({
    required ResourceKey resourceKey,
    required String platformId,
    required String accountIdentifier,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);
    final fullKey = resourceKey.fullKey;
    final memoryCacheKey = _makeMemoryCacheKey(fullKey, accountKey);

    // 从内存中删除
    _memoryCache.remove(memoryCacheKey);

    // 异步从数据库删除
    Future.microtask(() async {
      try {
        await _isar!.writeTxn(() async {
          await _isar!.resourceCacheEntitys
              .filter()
              .resourceKeyEqualTo(fullKey)
              .accountKeyEqualTo(accountKey)
              .deleteAll();
        });
      } catch (e) {
        CoreLogService.w('异步删除资源缓存失败: $e');
      }
    });
  }

  /// 清除指定账号的所有与账号相关的资源缓存
  Future<void> clearAccountRelatedCaches({
    required String platformId,
    required String accountIdentifier,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);

    // 从内存中删除所有账号相关的缓存
    final keysToRemove = <String>[];
    for (final entry in _memoryCache.entries) {
      if (entry.value.accountKey == accountKey &&
          entry.value.isAccountRelated) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _memoryCache.remove(key);
    }

    CoreLogService.i('已从内存清除 ${keysToRemove.length} 条账号关联缓存');

    // 异步从数据库删除
    Future.microtask(() async {
      try {
        await _isar!.writeTxn(() async {
          await _isar!.resourceCacheEntitys
              .filter()
              .accountKeyEqualTo(accountKey)
              .isAccountRelatedEqualTo(true)
              .deleteAll();
        });
      } catch (e) {
        CoreLogService.w('异步删除账号关联缓存失败: $e');
      }
    });
  }

  /// 清除指定账号的所有资源缓存
  Future<void> clearAllCaches({
    required String platformId,
    required String accountIdentifier,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);

    // 从内存中删除所有该账号的缓存
    final keysToRemove = <String>[];
    for (final entry in _memoryCache.entries) {
      if (entry.value.accountKey == accountKey) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _memoryCache.remove(key);
    }

    CoreLogService.i('已从内存清除 ${keysToRemove.length} 条账号缓存');

    // 异步从数据库删除
    Future.microtask(() async {
      try {
        await _isar!.writeTxn(() async {
          await _isar!.resourceCacheEntitys
              .filter()
              .accountKeyEqualTo(accountKey)
              .deleteAll();
        });
      } catch (e) {
        CoreLogService.w('异步删除账号缓存失败: $e');
      }
    });
  }

  /// 清除所有过期的缓存记录
  Future<void> clearExpiredCaches() async {
    _ensureInitialized();

    final now = DateTime.now();

    // 从内存中删除过期的缓存
    final keysToRemove = <String>[];
    for (final entry in _memoryCache.entries) {
      if (entry.value.expiryTime.isBefore(now)) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _memoryCache.remove(key);
    }

    CoreLogService.i('已从内存清除 ${keysToRemove.length} 条过期缓存');

    // 异步从数据库删除
    Future.microtask(() async {
      try {
        await _isar!.writeTxn(() async {
          await _isar!.resourceCacheEntitys
              .filter()
              .expiryTimeLessThan(now)
              .deleteAll();
        });
      } catch (e) {
        CoreLogService.w('异步删除过期缓存失败: $e');
      }
    });
  }

  /// 获取指定账号的所有缓存记录（用于调试）
  Future<List<ResourceCacheEntity>> getAllCaches({
    required String platformId,
    required String accountIdentifier,
  }) async {
    _ensureInitialized();

    final accountKey = _makeAccountKey(platformId, accountIdentifier);

    // 从内存中读取
    return _memoryCache.values
        .where((entity) => entity.accountKey == accountKey)
        .toList();
  }

  /// 获取数据库统计信息（用于调试）
  Future<Map<String, dynamic>> getStats() async {
    _ensureInitialized();

    final totalCount = _memoryCache.length;
    final now = DateTime.now();
    final expiredCount = _memoryCache.values
        .where((entity) => entity.expiryTime.isBefore(now))
        .length;

    return {
      'total': totalCount,
      'expired': expiredCount,
      'valid': totalCount - expiredCount,
      'inMemory': totalCount,
    };
  }

  /// 强制同步内存缓存到数据库（用于应用退出前）
  Future<void> syncToDatabase() async {
    if (!_initialized || _isar == null) return;

    try {
      CoreLogService.i('开始同步资源缓存到数据库...');

      await _isar!.writeTxn(() async {
        for (final entity in _memoryCache.values) {
          // 查找数据库中的现有记录
          final existing = await _isar!.resourceCacheEntitys
              .filter()
              .resourceKeyEqualTo(entity.resourceKey)
              .accountKeyEqualTo(entity.accountKey)
              .findFirst();

          if (existing != null) {
            entity.id = existing.id;
          }

          await _isar!.resourceCacheEntitys.put(entity);
        }
      });

      CoreLogService.i('资源缓存同步完成，共 ${_memoryCache.length} 条记录');
    } catch (e) {
      CoreLogService.e('同步资源缓存失败: $e');
    }
  }

  /// 关闭数据库
  Future<void> close() async {
    if (_isar != null) {
      // 在关闭前同步数据
      await syncToDatabase();

      await _isar!.close();
      _isar = null;
      _initialized = false;
      _memoryCache.clear();
    }
  }
}
