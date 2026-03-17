import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/core_context.dart';
import 'package:rank_hub/core/game_resource.dart';
import 'package:rank_hub/core/resource_key.dart';

/// 泛型资源 Provider
/// 根据 ResourceKey 自动加载和缓存资源数据
///
/// 特性:
/// - 类型安全: 自动推导资源类型 T
/// - 自动加载: 当 ref.watch 时自动触发资源加载
/// - 账号切换自动失效: 标记为 accountRelated 的资源会在账号切换时自动失效并重新加载
/// - 自动释放: 使用 autoDispose,当没有监听者时自动清理
/// - 依赖管理: 自动处理资源之间的依赖关系
///
/// 用法示例:
/// ```dart
/// // 在 Widget 中监听资源
/// final songListProvider = resourceProviderOf<List<Song>>(songListKey);
/// final songListState = ref.watch(songListProvider);
///
/// songListState.when(
///   data: (songs) => ListView.builder(
///     itemCount: songs.length,
///     itemBuilder: (context, index) => SongTile(songs[index]),
///   ),
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('错误: $e'),
/// );
///
/// // 强制刷新资源
/// await ref.read(refreshResourceProviderOf<List<Song>>(songListKey).future);
/// ```
final Map<ResourceKey, FutureProvider<dynamic>> _resourceProviders = {};

FutureProvider<T> resourceProviderOf<T>(ResourceKey<T> key) {
  final existing = _resourceProviders[key];
  if (existing != null) {
    return existing as FutureProvider<T>;
  }

  final provider = FutureProvider<T>((ref) async {
    // 获取当前的 AppContext
    // 监听 appContextProvider,当账号切换时会自动触发重建
    final appContext = ref.watch(appContextProvider);

    if (appContext == null) {
      throw Exception('AppContext 未初始化,无法加载资源');
    }

    // 通过 ResourceLoader 加载资源
    // 如果资源标记为 accountRelated,账号切换时会自动失效
    final result = await appContext.load(key);
    return result as T;
  });

  _resourceProviders[key] = provider;
  return provider;
}

/// 强制刷新指定资源
/// 用法: await ref.read(refreshResourceProviderOf<T>(key).future)
FutureProvider<void> refreshResourceProviderOf<T>(ResourceKey<T> key) {
  return FutureProvider<void>((ref) async {
    final appContext = ref.read(appContextProvider);

    if (appContext == null) {
      throw Exception('AppContext 未初始化,无法刷新资源');
    }

    // 强制刷新
    await appContext.forceRefresh(key);

    // 触发 resourceProviderOf 重新加载
    final provider = _resourceProviders[key];
    if (provider != null) {
      ref.invalidate(provider);
    }
  });
}

/// 尝试获取缓存资源(不触发加载)
/// 用法: final cached = ref.read(cachedResourceProviderOf<T>(key))
Provider<T?> cachedResourceProviderOf<T>(ResourceKey<T> key) {
  return Provider<T?>((ref) {
    final appContext = ref.read(appContextProvider);

    if (appContext == null) {
      return null;
    }

    final result = appContext.tryLoad(key);
    return result as T?;
  });
}

/// 批量资源加载 Provider
/// 用于同时加载多个资源,按照依赖关系自动排序
///
/// 用法示例:
/// ```dart
/// final keys = <ResourceKey>[songListKey, artistListKey, albumListKey];
/// final resultsAsync = ref.watch(batchResourceProviderOf(keys));
///
/// resultsAsync.when(
///   data: (results) {
///     final songs = results[songListKey] as List<Song>;
///     final artists = results[artistListKey] as List<Artist>;
///     // ...
///   },
///   loading: () => CircularProgressIndicator(),
///   error: (e, st) => Text('批量加载失败: $e'),
/// );
/// ```
FutureProvider<Map<ResourceKey, dynamic>> batchResourceProviderOf(
  List<ResourceKey> keys,
) {
  return FutureProvider<Map<ResourceKey, dynamic>>((ref) async {
    final appContext = ref.watch(appContextProvider);

    if (appContext == null) {
      throw Exception('AppContext 未初始化,无法批量加载资源');
    }

    // 通过 ResourceLoader 批量加载(会自动处理依赖关系)
    return await appContext.loader.loadMultiple(keys);
  });
}

/// Resource State Provider
/// 提供资源的实时状态(不触发加载)
/// 用于显示资源的加载状态,而不触发新的加载请求
///
/// 用法示例:
/// ```dart
/// final state = ref.watch(resourceStateProviderOf<List<Song>>(songListKey));
///
/// state.when(
///   data: (songs) => Text('已加载: ${songs.length} 首歌曲'),
///   loading: () => Text('加载中...'),
///   error: (e, st) => Text('错误: $e'),
/// );
/// ```
Provider<ResourceState<T>> resourceStateProviderOf<T>(ResourceKey<T> key) {
  return Provider<ResourceState<T>>((ref) {
    final appContext = ref.watch(appContextProvider);

    if (appContext == null) {
      return const AsyncLoading();
    }

    // 只读取当前状态,不触发加载
    final state = appContext.loader.watch(key);
    return state as ResourceState<T>;
  });
}
