import 'dart:convert';
import 'package:rank_hub/core/account.dart' as core;
import 'package:rank_hub/core/services/storage_service.dart';

/// 账号仓库
/// 封装账号的持久化操作，不含 UI 逻辑
class AccountRepository {
  final CoreStorageService _storage;

  AccountRepository({CoreStorageService? storage})
    : _storage = storage ?? CoreStorageService.instance;

  /// 获取所有账号
  Future<List<core.Account>> getAllAccounts() {
    return _storage.getAllAccounts();
  }

  /// 获取指定平台的账号
  Future<List<core.Account>> getAccountsByPlatform(String platformId) {
    return _storage.getAccountsByPlatform(platformId);
  }

  /// 保存账号
  Future<void> saveAccount(core.Account account, String accountIdentifier) {
    return _storage.saveAccount(account, accountIdentifier);
  }

  /// 删除账号
  Future<void> deleteAccount(String platformId, String accountIdentifier) {
    return _storage.deleteAccount(platformId, accountIdentifier);
  }

  /// 更新账号凭证
  Future<void> updateCredentials(
    String platformId,
    String accountIdentifier,
    Map<String, dynamic> newCredentials,
  ) {
    return _storage.updateAccountCredentials(
      platformId,
      accountIdentifier,
      newCredentials,
    );
  }

  /// 获取指定账号
  Future<core.Account?> getAccount(
    String platformId,
    String accountIdentifier,
  ) async {
    final entity = await _storage.getAccountEntity(
      platformId,
      accountIdentifier,
    );
    if (entity == null) return null;

    final credentials = entity.credentialsJson.isNotEmpty
        ? Map<String, dynamic>.from(jsonDecode(entity.credentialsJson) as Map)
        : <String, dynamic>{};

    final metadata = entity.metadataJson == null || entity.metadataJson!.isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(entity.metadataJson!) as Map);

    return core.Account(
      platformId: entity.platformId,
      credentials: credentials,
      displayName: entity.displayName,
      avatarUrl: entity.avatarUrl,
      metadata: metadata,
    );
  }

  /// 获取游戏绑定的账号
  Future<core.Account?> getSelectedAccountForGame(String gameId) {
    return _storage.getSelectedAccount(gameId);
  }

  /// 设置游戏绑定的账号
  Future<void> setSelectedAccountForGame(
    String gameId,
    String platformId,
    String accountIdentifier,
  ) {
    return _storage.setSelectedAccountForGame(
      gameId,
      platformId,
      accountIdentifier,
    );
  }

  /// 清除游戏绑定的账号
  Future<void> clearSelectedAccountForGame(String gameId) {
    return _storage.clearSelectedAccountForGame(gameId);
  }
}
