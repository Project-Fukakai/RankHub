import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/repositories/account_repository.dart';
import 'package:rank_hub/core/viewmodels/game_selection_view_model.dart';

/// 账号管理状态
class AccountState {
  final List<Account> allAccounts;
  final Account? currentAccount;
  final List<Account> accountsForCurrentGame;
  final bool isLoading;
  final String? errorMessage;

  const AccountState({
    this.allAccounts = const [],
    this.currentAccount,
    this.accountsForCurrentGame = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AccountState copyWith({
    List<Account>? allAccounts,
    Account? currentAccount,
    List<Account>? accountsForCurrentGame,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AccountState(
      allAccounts: allAccounts ?? this.allAccounts,
      currentAccount: currentAccount ?? this.currentAccount,
      accountsForCurrentGame:
          accountsForCurrentGame ?? this.accountsForCurrentGame,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// 账号管理 ViewModel
/// 依赖 gameSelectionViewModel，游戏切换时自动更新可用账号
class AccountViewModel extends Notifier<AccountState> {
  late final AccountRepository _repository;

  @override
  AccountState build() {
    _repository = AccountRepository();

    // 监听游戏切换
    ref.listen(gameSelectionViewModelProvider, (previous, next) {
      if (previous?.selectedGame != next.selectedGame) {
        _onGameChanged(next.selectedGame);
      }
    });

    // 异步初始化
    Future.microtask(() => loadAccounts());

    return const AccountState(isLoading: true);
  }

  /// 加载所有账号
  Future<void> loadAccounts() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final accounts = await _repository.getAllAccounts();
      state = state.copyWith(allAccounts: accounts, isLoading: false);

      // 加载当前游戏的账号
      await _loadCurrentGameAccount();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '加载账号失败: $e');
    }
  }

  /// 游戏切换时的处理
  Future<void> _onGameChanged(Game? game) async {
    if (game == null) {
      state = state.copyWith(currentAccount: null, accountsForCurrentGame: []);
      return;
    }

    await _loadCurrentGameAccount();
  }

  /// 加载当前游戏的账号
  Future<void> _loadCurrentGameAccount() async {
    final gameState = ref.read(gameSelectionViewModelProvider);
    final game = gameState.selectedGame;

    if (game == null) {
      state = state.copyWith(currentAccount: null, accountsForCurrentGame: []);
      return;
    }

    // 获取支持当前游戏的平台列表
    final supportedPlatforms = CoreProvider.instance.getPlatformsForGame(
      game.id.value,
    );
    final supportedPlatformIds = supportedPlatforms
        .map((p) => p.id.value)
        .toSet();

    // 筛选出支持当前游戏的账号
    final compatibleAccounts = state.allAccounts
        .where((account) => supportedPlatformIds.contains(account.platformId))
        .toList();

    // 尝试加载该游戏绑定的账号
    final boundAccount = await _repository.getSelectedAccountForGame(
      game.id.value,
    );

    state = state.copyWith(
      currentAccount: boundAccount,
      accountsForCurrentGame: compatibleAccounts,
    );
  }

  /// 绑定账号（简化版，不含 UI 逻辑）
  Future<void> bindAccount(
    Account account,
    String accountIdentifier,
    String displayName,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final updatedAccount = account.copyWith(displayName: displayName);
      await _repository.saveAccount(updatedAccount, accountIdentifier);
      await loadAccounts();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '绑定账号失败: $e');
    }
  }

  /// 通过登录结果创建并绑定账号（统一转换流程）
  Future<void> bindLoginResult(
    PlatformId platformId,
    PlatformLoginResult result,
  ) async {
    final provider = CoreProvider.instance.getCredentialProvider(
      platformId.value,
    );

    final account = Account(
      platformId: platformId.value,
      credentials: {},
      displayName: result.displayName,
      avatarUrl: result.avatarUrl,
      metadata: {
        if (result.externalId.isNotEmpty) 'external_id': result.externalId,
        if (result.displayName != null) 'display_name': result.displayName,
        if (result.avatarUrl != null) 'avatar_url': result.avatarUrl,
        if (result.metadata != null) 'metadata': result.metadata,
      },
    );

    if (provider != null) {
      await provider.createCredential(account, result.credentialData);
    } else {
      account.credentials.addAll(result.credentialData);
    }

    final identifier = result.externalId.isNotEmpty
        ? result.externalId
        : account.externalId ?? account.username ?? account.platformId;

    final displayName =
        account.resolvedDisplayName ?? result.displayName ?? 'Unknown';

    await bindAccount(account, identifier, displayName);

    final boundAccount = account.copyWith(
      displayName: displayName,
      avatarUrl: account.avatarUrl ?? result.avatarUrl,
    );
    await switchAccount(boundAccount, identifier);
  }

  /// 解绑账号
  Future<void> unbindAccount(
    String platformId,
    String accountIdentifier,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await _repository.deleteAccount(platformId, accountIdentifier);
      await loadAccounts();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '解绑账号失败: $e');
    }
  }

  /// 切换账号
  Future<void> switchAccount(Account account, String accountIdentifier) async {
    final gameState = ref.read(gameSelectionViewModelProvider);
    final game = gameState.selectedGame;

    if (game == null) return;

    try {
      await _repository.setSelectedAccountForGame(
        game.id.value,
        account.platformId,
        accountIdentifier,
      );

      state = state.copyWith(currentAccount: account);

      // 通知 CoreProvider 更新上下文
      await CoreProvider.instance.setCurrentAccount(account, ref);
    } catch (e) {
      state = state.copyWith(errorMessage: '切换账号失败: $e');
    }
  }
}

final accountViewModelProvider =
    NotifierProvider<AccountViewModel, AccountState>(() => AccountViewModel());
