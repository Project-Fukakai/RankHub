import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_loader.dart';
import 'package:rank_hub/core/resource_scope.dart';
import 'package:rank_hub/core/resource_key.dart';

/// 应用上下文（不可变）
/// 封装游戏、账号、Scope、Loader、适配器等
/// 切换游戏/账号 = 重建整个 Context
class AppContext {
  final Game game;
  final Account? account;
  final ResourceScope scope;
  final ResourceLoader loader;
  final List<PlatformAdapter> adapters;

  const AppContext({
    required this.game,
    required this.account,
    required this.scope,
    required this.loader,
    required this.adapters,
  });

  /// 通过 Loader 加载资源
  Future<T> load<T>(ResourceKey key) {
    return loader.load<T>(key);
  }

  /// 尝试读取资源（不触发 fetch）
  Future<T?> tryLoad<T>(ResourceKey key) {
    return loader.tryLoad<T>(key);
  }

  /// 强制刷新资源
  Future<T> forceRefresh<T>(ResourceKey key) {
    return loader.forceRefresh<T>(key);
  }

  /// 判断是否有账号
  bool get hasAccount => account != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppContext &&
        other.game == game &&
        other.account == account &&
        other.scope == scope;
  }

  @override
  int get hashCode => game.hashCode ^ (account?.hashCode ?? 0) ^ scope.hashCode;
}

/// 应用上下文状态管理
/// 负责维护当前的 Context，并在游戏/账号切换时重建
class AppContextNotifier extends Notifier<AppContext?> {
  @override
  AppContext? build() {
    return null;
  }

  /// 构建新的 Context（完全重建 Scope + Loader）
  /// 用于游戏切换或账号切换
  void buildContext({
    required Game game,
    Account? account,
    required List<PlatformAdapter> adapters,
    required ResourceLoader Function(
      ResourceScope scope,
      List<PlatformAdapter> adapters,
      Account? account,
    )
    loaderFactory,
  }) {
    // 构建不可变的 Scope
    final scope = account != null
        ? ResourceScope(
            gameId: game.id,
            platformId: PlatformId(account.platformId),
            accountIdentifier: _extractAccountIdentifier(account),
          )
        : ResourceScope.guest(
            gameId: game.id,
            platformId: PlatformId(game.id.platform),
          );

    // 创建新的 Loader
    final loader = loaderFactory(scope, adapters, account);

    // 构建新的 Context
    state = AppContext(
      game: game,
      account: account,
      scope: scope,
      loader: loader,
      adapters: adapters,
    );
  }

  /// 清空 Context
  void clear() {
    state = null;
  }

  /// 从账号中提取标识符
  String _extractAccountIdentifier(Account account) {
    return account.externalId ?? account.username ?? account.platformId;
  }
}

/// 应用上下文 Provider
final appContextProvider = NotifierProvider<AppContextNotifier, AppContext?>(
  () => AppContextNotifier(),
);
