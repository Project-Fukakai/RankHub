import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/core/resource_scope.dart';

abstract class GameResourceDefinition<T> {
  const GameResourceDefinition();

  ResourceKey<T> get key;

  /// 该资源由哪些平台提供（显式声明）
  List<PlatformId> get providedPlatforms;

  /// 资源的有效期（秒）。如果为 null，缓存永不过期。
  Duration? get ttl => null;

  /// 此资源依赖的其他资源，必须先加载。
  List<ResourceKey> get dependencies => const [];

  /// 当触发刷新时，是否强制重新拉取数据。
  bool get forceRefreshWhenTriggered => true;

  /// 此资源是否关联账号。
  /// 如果为 true，当账号切换时，该资源会自动失效并重新拉取。
  bool get accountRelated => false;

  /// 从远端拉取资源（依赖 Scope、适配器与账号）
  Future<T> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  );

  /// 从本地缓存加载
  Future<T?> loadCache(ResourceScope scope, Account? account);

  /// 持久化到本地
  Future<void> persist(T data);
}

abstract class GameToolDefinition<T> {
  ResourceKey<T> get key;

  /// 创建工具实例（只依赖不可变的 Scope 和适配器列表）
  T createTool(ResourceScope scope, List<PlatformAdapter> adapters);
}
