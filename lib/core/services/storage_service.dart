import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/models/account_entity.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/core/services/resource_cache_service.dart';

/// 存储服务
/// 使用 Isar 存储账号数据，使用 SharedPreferences 存储游戏选择的账号映射
class CoreStorageService {
  static CoreStorageService? _instance;
  static CoreStorageService get instance {
    _instance ??= CoreStorageService._();
    return _instance!;
  }

  CoreStorageService._();

  Isar? _isar;
  SharedPreferences? _prefs;
  bool _initialized = false;

  /// 初始化服务
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 初始化 Isar
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [AccountEntitySchema],
        directory: dir.path,
        name: 'core_accounts',
      );

      // 初始化 SharedPreferences
      _prefs = await SharedPreferences.getInstance();

      // 初始化资源缓存服务
      await ResourceCacheService.instance.initialize();

      _initialized = true;
    } catch (e) {
      CoreLogService.e('存储服务初始化失败: $e');
      rethrow;
    }
  }

  void _ensureInitialized() {
    if (!_initialized || _isar == null || _prefs == null) {
      throw StateError('CoreStorageService 未初始化，请先调用 initialize()');
    }
  }

  /// 保存账号
  Future<void> saveAccount(Account account, String accountIdentifier) async {
    _ensureInitialized();

    final credentialsJson = jsonEncode(account.credentials);
    final metadataJson = account.metadata.isNotEmpty
        ? jsonEncode(account.metadata)
        : null;
    final resolvedDisplayName = _resolveDisplayName(account) ?? 'Unknown';
    final resolvedAvatarUrl = _resolveAvatarUrl(account);

    final entity = AccountEntity.create(
      platformId: account.platformId,
      accountIdentifier: accountIdentifier,
      displayName: resolvedDisplayName,
      avatarUrl: resolvedAvatarUrl,
      credentialsJson: credentialsJson,
      metadataJson: metadataJson,
    );

    await _isar!.writeTxn(() async {
      // 查找是否已存在
      final existing = await _isar!.accountEntitys
          .filter()
          .platformIdEqualTo(account.platformId)
          .and()
          .accountIdentifierEqualTo(accountIdentifier)
          .findFirst();

      if (existing != null) {
        // 更新现有账号
        entity.id = existing.id;
        entity.createdAt = existing.createdAt;
        entity.updatedAt = DateTime.now();
        if (entity.avatarUrl == null || entity.avatarUrl!.isEmpty) {
          entity.avatarUrl = existing.avatarUrl;
        }
        if (entity.metadataJson == null || entity.metadataJson!.isEmpty) {
          entity.metadataJson = existing.metadataJson;
        }
      }

      await _isar!.accountEntitys.put(entity);
    });
  }

  /// 获取指定平台的所有账号
  Future<List<Account>> getAccountsByPlatform(String platformId) async {
    _ensureInitialized();

    final entities = await _isar!.accountEntitys
        .filter()
        .platformIdEqualTo(platformId)
        .findAll();

    return entities.map(_buildAccountFromEntity).toList();
  }

  /// 获取所有账号
  Future<List<Account>> getAllAccounts() async {
    _ensureInitialized();

    final entities = await _isar!.accountEntitys.where().findAll();

    return entities.map(_buildAccountFromEntity).toList();
  }

  /// 获取账号实体（包含显示名称等元数据）
  Future<AccountEntity?> getAccountEntity(
    String platformId,
    String accountIdentifier,
  ) async {
    _ensureInitialized();

    return await _isar!.accountEntitys
        .filter()
        .platformIdEqualTo(platformId)
        .and()
        .accountIdentifierEqualTo(accountIdentifier)
        .findFirst();
  }

  /// 获取指定平台的所有账号实体
  Future<List<AccountEntity>> getAccountEntitiesByPlatform(
    String platformId,
  ) async {
    _ensureInitialized();

    return await _isar!.accountEntitys
        .filter()
        .platformIdEqualTo(platformId)
        .sortByDisplayName()
        .findAll();
  }

  /// 删除账号
  Future<void> deleteAccount(
    String platformId,
    String accountIdentifier,
  ) async {
    _ensureInitialized();

    await _isar!.writeTxn(() async {
      final entity = await _isar!.accountEntitys
          .filter()
          .platformIdEqualTo(platformId)
          .and()
          .accountIdentifierEqualTo(accountIdentifier)
          .findFirst();

      if (entity != null) {
        await _isar!.accountEntitys.delete(entity.id);
      }
    });

    // 清除相关的游戏账号选择
    await _clearGameAccountSelections(platformId, accountIdentifier);
  }

  /// 更新账号凭证
  Future<void> updateAccountCredentials(
    String platformId,
    String accountIdentifier,
    Map<String, dynamic> newCredentials,
  ) async {
    _ensureInitialized();

    await _isar!.writeTxn(() async {
      final entity = await _isar!.accountEntitys
          .filter()
          .platformIdEqualTo(platformId)
          .and()
          .accountIdentifierEqualTo(accountIdentifier)
          .findFirst();

      if (entity != null) {
        entity.credentialsJson = jsonEncode(newCredentials);
        entity.updatedAt = DateTime.now();
        await _isar!.accountEntitys.put(entity);
      }
    });
  }

  // ==================== 游戏账号选择管理 ====================

  /// 获取游戏选择的账号标识符
  /// Key 格式: "game_account_{gameId}"
  Future<String?> getSelectedAccountForGame(String gameId) async {
    _ensureInitialized();
    return _prefs!.getString('game_account_$gameId');
  }

  /// 设置游戏选择的账号
  Future<void> setSelectedAccountForGame(
    String gameId,
    String platformId,
    String accountIdentifier,
  ) async {
    _ensureInitialized();

    // 存储格式: "platformId:accountIdentifier"
    final value = '$platformId:$accountIdentifier';
    await _prefs!.setString('game_account_$gameId', value);
  }

  /// 清除游戏选择的账号
  Future<void> clearSelectedAccountForGame(String gameId) async {
    _ensureInitialized();
    await _prefs!.remove('game_account_$gameId');
  }

  /// 根据游戏 ID 获取选择的账号
  Future<Account?> getSelectedAccount(String gameId) async {
    _ensureInitialized();

    final selection = await getSelectedAccountForGame(gameId);
    if (selection == null) return null;

    final parts = selection.split(':');
    if (parts.length != 2) return null;

    final platformId = parts[0];
    final accountIdentifier = parts[1];

    final entity = await getAccountEntity(platformId, accountIdentifier);
    if (entity == null) return null;

    return _buildAccountFromEntity(entity);
  }

  Account _buildAccountFromEntity(AccountEntity entity) {
    final credentials =
        jsonDecode(entity.credentialsJson) as Map<String, dynamic>;
    final metadata = entity.metadataJson == null || entity.metadataJson!.isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(
            jsonDecode(entity.metadataJson!) as Map,
          );

    return Account(
      platformId: entity.platformId,
      credentials: credentials,
      displayName: entity.displayName,
      avatarUrl: entity.avatarUrl,
      metadata: metadata,
    );
  }

  String? _resolveDisplayName(Account account) {
    final candidate = account.resolvedDisplayName;
    if (candidate == null || candidate.isEmpty) return null;
    return candidate;
  }

  String? _resolveAvatarUrl(Account account) {
    final candidate = account.resolvedAvatarUrl;
    if (candidate == null || candidate.isEmpty) return null;
    return candidate;
  }

  /// 清除指定账号相关的所有游戏选择
  Future<void> _clearGameAccountSelections(
    String platformId,
    String accountIdentifier,
  ) async {
    _ensureInitialized();

    final prefix = 'game_account_';
    final targetValue = '$platformId:$accountIdentifier';

    final keys = _prefs!.getKeys();
    final keysToRemove = keys.where((key) {
      if (key.startsWith(prefix)) {
        final value = _prefs!.getString(key);
        return value == targetValue;
      }
      return false;
    }).toList();

    for (final key in keysToRemove) {
      await _prefs!.remove(key);
    }
  }

  /// 获取所有游戏的账号选择映射
  Future<Map<String, String>> getAllGameAccountSelections() async {
    _ensureInitialized();

    final prefix = 'game_account_';
    final keys = _prefs!.getKeys();
    final result = <String, String>{};

    for (final key in keys) {
      if (key.startsWith(prefix)) {
        final gameId = key.substring(prefix.length);
        final value = _prefs!.getString(key);
        if (value != null) {
          result[gameId] = value;
        }
      }
    }

    return result;
  }

  // ==================== 上次选择的游戏管理 ====================

  static const String _lastSelectedGameKey = 'last_selected_game';

  /// 获取上次选择的游戏 ID
  Future<String?> getLastSelectedGameId() async {
    _ensureInitialized();
    return _prefs!.getString(_lastSelectedGameKey);
  }

  /// 保存上次选择的游戏 ID
  Future<void> setLastSelectedGameId(String gameId) async {
    _ensureInitialized();
    await _prefs!.setString(_lastSelectedGameKey, gameId);
  }

  /// 清除上次选择的游戏
  Future<void> clearLastSelectedGameId() async {
    _ensureInitialized();
    await _prefs!.remove(_lastSelectedGameKey);
  }

  // ==================== 加载游戏和账号 ====================

  /// 加载上次选择的游戏和对应账号
  ///
  /// 从 SharedPreferences 读取上次选择的游戏，如果没有或游戏不存在则选择第一个
  /// 然后从存储中加载该游戏对应的账号
  ///
  /// 返回: (selectedGame, account) 的元组，如果没有可用游戏则返回 (null, null)
  Future<(Game?, Account?)> loadLastSelectedGameAndAccount(
    List<Game> availableGames,
  ) async {
    _ensureInitialized();

    if (availableGames.isEmpty) {
      return (null, null);
    }

    Game? selectedGame;

    // 尝试从 SharedPreferences 读取上次选择的游戏
    final lastGameId = await getLastSelectedGameId();
    if (lastGameId != null) {
      // 查找匹配的游戏
      try {
        selectedGame = availableGames.firstWhere(
          (game) => game.id.value == lastGameId,
        );
      } catch (e) {
        // 如果找不到上次选择的游戏，使用第一个
        CoreLogService.w('上次选择的游戏 $lastGameId 不存在，使用第一个游戏');
        selectedGame = availableGames.first;
      }
    } else {
      // 如果没有保存的游戏选择，使用第一个
      selectedGame = availableGames.first;
    }

    // 从存储中加载该游戏选择的账号
    final account = await getSelectedAccount(selectedGame.id.value);

    return (selectedGame, account);
  }

  // ==================== 关闭服务 ====================

  /// 关闭服务
  Future<void> close() async {
    // 先同步资源缓存到数据库
    await ResourceCacheService.instance.syncToDatabase();

    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
    }
    _isar = null;
    _prefs = null;
    _initialized = false;

    // 关闭资源缓存服务
    await ResourceCacheService.instance.close();
  }
}
