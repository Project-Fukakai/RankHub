import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/core_context.dart';
import 'package:rank_hub/core/credential_provider.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/game_registry_provider.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_loader.dart';
import 'package:rank_hub/core/resource_registry_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/core/services/storage_service.dart';
import 'package:rank_hub/platforms/platform_descriptor.dart';
import 'package:rank_hub/platforms/platform_registry.dart';
import 'package:rank_hub/services/isar_service.dart';

class CoreProvider {
  // 单例模式
  static CoreProvider? _instance;

  CoreProvider._();

  /// 获取单例实例
  static CoreProvider get instance {
    _instance ??= CoreProvider._();
    return _instance!;
  }

  // ==================== 注册表 ====================

  /// 平台注册表
  final PlatformRegistry platformRegistry = PlatformRegistry();

  /// 游戏注册表
  final GameRegistryProvider gameRegistry = GameRegistryProvider();

  /// 资源注册表
  final ResourceRegistryProvider resourceRegistry = ResourceRegistryProvider();

  /// 存储服务
  final CoreStorageService coreStorage = CoreStorageService.instance;

  // ==================== 获取方法 ====================

  /// 获取凭据提供者
  CredentialProvider? getCredentialProvider(String platformId) {
    return platformRegistry.getCredentialProvider(PlatformId(platformId));
  }

  /// 获取登录处理器
  PlatformLoginHandler? getLoginHandler(String platformId) {
    return platformRegistry.getLoginHandler(PlatformId(platformId));
  }

  /// 获取所有凭据提供者
  List<CredentialProvider> getAllCredentialProviders() {
    return platformRegistry.getAllCredentialProviders();
  }

  /// 获取所有登录处理器
  List<PlatformLoginHandler> getAllLoginHandlers() {
    return platformRegistry.getAllLoginHandlers();
  }

  // ==================== 平台-游戏关联便捷方法 ====================

  /// 获取平台支持的所有游戏
  ///
  /// [platformId] 平台ID字符串
  List<Game> getGamesByPlatform(String platformId) {
    final gameIds = platformRegistry.getGamesForPlatform(
      PlatformId(platformId),
    );
    return gameRegistry.getGamesByIdStrings(
      gameIds.map((id) => id.value).toList(),
    );
  }

  /// 获取支持某个游戏的所有平台
  ///
  /// [gameIdString] 游戏ID字符串
  List<PlatformDescriptor> getPlatformsForGame(String gameIdString) {
    // 先找到游戏对象以获取完整的 GameId
    final game = gameRegistry.findByIdString(gameIdString);
    if (game == null) return [];
    return platformRegistry.getPlatformsForGame(game.id);
  }

  /// 检查平台是否支持某个游戏
  ///
  /// [platformId] 平台ID字符串
  /// [gameIdString] 游戏ID字符串
  bool isPlatformSupportGame(String platformId, String gameIdString) {
    final game = gameRegistry.findByIdString(gameIdString);
    if (game == null) return false;
    return platformRegistry.isPlatformSupportGame(
      PlatformId(platformId),
      game.id,
    );
  }

  // ==================== 初始化和清理 ====================

  /// 初始化服务提供者
  Future<void> initialize() async {
    // 初始化存储服务
    await coreStorage.initialize();
  }

  /// 清理所有服务
  Future<void> dispose() async {
    platformRegistry.clear();
    gameRegistry.clear();
    resourceRegistry.clear();

    // 关闭存储服务
    await coreStorage.close();
  }

  // ==================== 上下文管理副作用方法 ====================

  /// 在应用启动时初始化 AppContext
  /// 优先使用上次选择的游戏和账号，保证资源加载有上下文
  Future<void> initializeAppContext(AppContextNotifier notifier) async {
    try {
      final games = gameRegistry.getAllGames();
      if (games.isEmpty) return;

      final lastGameId = await coreStorage.getLastSelectedGameId();
      final selectedGame =
          lastGameId != null
              ? gameRegistry.findByIdString(lastGameId)
              : null;
      final game = selectedGame ?? games.first;

      Account? account = await coreStorage.getSelectedAccount(game.id.value);
      final isCompatible = account != null &&
          await _checkAccountGameCompatibility(account, game);
      if (!isCompatible) {
        account = await _findCompatibleAccountForGame(game);
        if (account != null) {
          await coreStorage.setSelectedAccountForGame(
            game.id.value,
            account.platformId,
            _getAccountIdentifier(account),
          );
        }
      }
      await _buildContext(game, account, notifier);
    } catch (e) {
      CoreLogService.w('初始化 AppContext 失败: $e');
    }
  }

  /// 设置当前游戏
  /// 会自动保存选择并更新上下文
  Future<void> setCurrentGame(Game game, Ref ref) async {
    try {
      // 保存游戏选择
      await coreStorage.setLastSelectedGameId(game.id.value);

      // 加载该游戏对应的账号
      Account? account = await coreStorage.getSelectedAccount(game.id.value);
      final isCompatible = account != null &&
          await _checkAccountGameCompatibility(account, game);
      if (!isCompatible) {
        account = await _findCompatibleAccountForGame(game);
        if (account != null) {
          await coreStorage.setSelectedAccountForGame(
            game.id.value,
            account.platformId,
            _getAccountIdentifier(account),
          );
        }
      }

      // 重建 AppContext
      final notifier = ref.read(appContextProvider.notifier);
      await _buildContext(game, account, notifier);
    } catch (e) {
      CoreLogService.w('设置当前游戏失败: $e');
      rethrow;
    }
  }

  /// 设置当前账号
  /// 会自动检查账号与游戏的匹配，必要时切换游戏
  Future<void> setCurrentAccount(Account account, Ref ref) async {
    try {
      final currentContext = ref.read(appContextProvider);
      final currentGame = currentContext?.game;

      // 检查账号是否与当前游戏匹配
      if (currentGame != null) {
        final isCompatible = await _checkAccountGameCompatibility(
          account,
          currentGame,
        );

        if (!isCompatible) {
          // 账号与当前游戏不匹配，需要切换游戏
          await _switchToCompatibleGame(account, ref);
          return;
        }
      }

      // 账号与游戏匹配，重建 Context
      if (currentGame != null) {
        await coreStorage.setSelectedAccountForGame(
          currentGame.id.value,
          account.platformId,
          _getAccountIdentifier(account),
        );

        // 重建 AppContext（账号切换）
        final notifier = ref.read(appContextProvider.notifier);
        await _buildContext(currentGame, account, notifier);
      }
    } catch (e) {
      CoreLogService.w('设置当前账号失败: $e');
      rethrow;
    }
  }

  /// 检查账号与游戏的兼容性
  Future<bool> _checkAccountGameCompatibility(
    Account account,
    Game game,
  ) async {
    // 获取支持该游戏的所有平台
    final supportedPlatforms = platformRegistry
        .getPlatformsForGame(game.id)
        .map((platform) => platform.id.value)
        .toList();

    // 检查账号的平台是否在支持列表中
    final isCompatible = supportedPlatforms.any(
      (platformId) => platformId == account.platformId,
    );

    if (!isCompatible) {
      CoreLogService.w(
        '账号平台 ${account.platformId} 不支持游戏 ${game.id.value} '
        '(支持的平台: ${supportedPlatforms.join(", ")})',
      );
    }

    return isCompatible;
  }

  /// 切换到与账号兼容的游戏
  Future<void> _switchToCompatibleGame(Account account, Ref ref) async {
    try {
      // 1. 尝试从历史记录中获取该账号最后使用的游戏
      final accountId = _getAccountIdentifier(account);
      final lastGameId = await _getLastGameForAccount(
        account.platformId,
        accountId,
      );

      Game? targetGame;

      if (lastGameId != null) {
        // 查找对应的游戏
        final allGames = gameRegistry.getAllGames();
        try {
          targetGame = allGames.firstWhere((g) => g.id.value == lastGameId);
        } catch (e) {
          // 历史游戏不存在
        }
      }

      // 2. 如果没有历史记录或历史游戏不存在，选择第一个兼容的游戏
      targetGame ??= await _findFirstCompatibleGame(account);

      // 3. 切换到目标游戏
      if (targetGame != null) {
        await setCurrentGame(targetGame, ref);

        // 保存账号选择
        await coreStorage.setSelectedAccountForGame(
          targetGame.id.value,
          account.platformId,
          accountId,
        );

        // 重建 AppContext
        final notifier = ref.read(appContextProvider.notifier);
        await _buildContext(targetGame, account, notifier);
      } else {
        CoreLogService.w('没有找到与账号兼容的游戏');
      }
    } catch (e) {
      CoreLogService.w('切换兼容游戏失败: $e');
      rethrow;
    }
  }

  /// 查找第一个与账号兼容的游戏
  Future<Game?> _findFirstCompatibleGame(Account account) async {
    final allGames = gameRegistry.getAllGames();

    for (final game in allGames) {
      if (await _checkAccountGameCompatibility(account, game)) {
        return game;
      }
    }

    return allGames.isNotEmpty ? allGames.first : null;
  }

  /// 为指定游戏查找可用账号
  Future<Account?> _findCompatibleAccountForGame(Game game) async {
    final supportedPlatforms = platformRegistry
        .getPlatformsForGame(game.id)
        .map((platform) => platform.id.value)
        .toList();

    for (final platformId in supportedPlatforms) {
      final accounts = await coreStorage.getAccountsByPlatform(platformId);
      if (accounts.isNotEmpty) return accounts.first;
    }

    return null;
  }

  /// 获取账号最后使用的游戏ID
  Future<String?> _getLastGameForAccount(
    String platformId,
    String accountId,
  ) async {
    // 从存储的元数据中获取
    // 可以扩展 AccountEntity 来存储最后使用的游戏ID
    // 目前返回null，表示没有历史记录
    return null;
  }

  /// 构建应用上下文（完全重建 Scope + Loader）
  Future<void> _buildContext(
    Game game,
    Account? account,
    AppContextNotifier notifier,
  ) async {
    try {
      await _warmupIsarForGame(game);
      final adapters = platformRegistry.getAdaptersForGame(game.id);

      notifier.buildContext(
        game: game,
        account: account,
        adapters: adapters,
        loaderFactory: (scope, adapters, account) => ResourceLoader(
          registry: resourceRegistry,
          scope: scope,
          adapters: adapters,
          account: account,
          platformRegistry: platformRegistry,
        ),
      );

      if (account != null) {
        CoreLogService.i(
          '已重建 AppContext: ${game.id.value}, '
          'account: ${_getAccountIdentifier(account)}',
        );
      } else {
        CoreLogService.i('已重建游客 AppContext: ${game.id.value}');
      }
    } catch (e) {
      CoreLogService.w('构建应用上下文失败: $e');
    }
  }

  /// 从账号中提取标识符
  String _getAccountIdentifier(Account account) {
    // 从凭证中提取账号标识符
    // 不同平台可能有不同的标识字段
    return account.externalId ?? account.username ?? account.platformId;
  }

  Future<void> _warmupIsarForGame(Game game) async {
    switch (game.id.name) {
      case 'phigros':
        await IsarService.instance.phigros.db;
        break;
      default:
        break;
    }
  }

  // ==================== 统计信息 ====================

  /// 获取服务统计信息
  Map<String, dynamic> getStats() {
    return {
      'platforms': platformRegistry.platformCount,
      'games': gameRegistry.gameCount,
      'resources': resourceRegistry.getStats(),
      'adapters': platformRegistry.adapterCount,
      'credential_providers': platformRegistry.credentialProviderCount,
      'login_handlers': platformRegistry.loginHandlerCount,
    };
  }

  /// 打印服务统计信息
  void printStats() {
    final stats = getStats();
    CoreLogService.i(
      'Core Provider Stats | '
      'Platforms: ${stats['platforms']}, '
      'Games: ${stats['games']}, '
      'Resources: ${stats['resources']}, '
      'Adapters: ${stats['adapters']}, '
      'Credential Providers: ${stats['credential_providers']}, '
      'Login Handlers: ${stats['login_handlers']}',
    );
  }
}
