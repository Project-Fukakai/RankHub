import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/credential.dart';
import 'package:rank_hub/core/platform_id.dart';

/// 凭据过期异常
class CredentialExpiredException implements Exception {
  final String message;
  final Account account;

  CredentialExpiredException(this.account, [this.message = '凭据已失效，请重新登录']);

  @override
  String toString() => message;
}

/// 凭据提供者抽象接口
/// 负责管理不同平台的凭据获取、刷新等操作
abstract class CredentialProvider {
  /// 平台ID
  PlatformId get platformId;

  /// 获取有效的凭据（如果凭据过期或即将过期，会自动刷新）
  /// 返回更新后的 Account 对象
  Future<Account> getCredential(Account account);

  /// 刷新凭据
  /// 返回更新后的 Account 对象
  Future<Account> refreshCredential(Account account);

  /// 验证凭据是否有效
  Future<bool> validateCredential(Account account);

  /// 创建新凭据
  /// 修改 Account 对象中的凭据字段
  Future<void> createCredential(Account account, Map<String, dynamic> data);

  /// 撤销凭据
  Future<void> revokeCredential(Account account);
}

/// API Key 凭据提供者
abstract class ApiKeyCredentialProvider extends CredentialProvider {
  @override
  Future<Account> getCredential(Account account) async {
    // API Key 类型的凭据通常不需要刷新，直接返回
    final credential = account.credential;
    final apiKey = credential is ApiKeyCredential
        ? credential.apiKey
        : account.credentials['api_key'] as String?;
    if (apiKey == null || apiKey.isEmpty) {
      throw CredentialExpiredException(account, '缺少 API Key');
    }
    return account;
  }

  @override
  Future<Account> refreshCredential(Account account) async {
    // API Key 通常不支持刷新，直接返回原账号
    return account;
  }
}

/// OAuth2 凭据提供者
abstract class OAuth2CredentialProvider extends CredentialProvider {
  @override
  Future<Account> getCredential(Account account) async {
    final credential = account.credential;
    final accessToken = credential is JwtCredential
        ? credential.token
        : account.credentials['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw CredentialExpiredException(account, '缺少访问令牌');
    }

    // 如果令牌过期或即将过期，自动刷新
    if (_isTokenExpired(account) || _isTokenExpiringSoon(account)) {
      return await refreshCredential(account);
    }

    return account;
  }

  @override
  Future<Account> refreshCredential(Account account) async {
    final cred = account.credential;
    final refreshToken = cred is JwtCredential
        ? cred.refreshToken
        : account.credentials['refresh_token'] as String?;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw CredentialExpiredException(account, '缺少刷新令牌，请重新登录');
    }

    try {
      // 调用具体平台的刷新逻辑
      final newTokenData = await requestTokenRefresh(refreshToken);

      // 更新账号中的凭据字段
      final expiresAt = newTokenData.containsKey('expires_in')
          ? DateTime.now().add(
              Duration(seconds: newTokenData['expires_in'] as int),
            )
          : null;
      final newCredential = JwtCredential(
        token: newTokenData['access_token'] as String,
        refreshToken: (newTokenData['refresh_token'] as String?) ?? refreshToken,
        expiresAt: expiresAt,
      );
      final newCredentials = newCredential.toJson();
      newCredentials['credential_updated_at'] =
          DateTime.now().toIso8601String();

      return Account(
        platformId: account.platformId,
        credentials: newCredentials,
      );
    } catch (e) {
      // 刷新失败，凭据已完全失效
      throw CredentialExpiredException(account, '刷新凭据失败: $e');
    }
  }

  /// 请求刷新令牌 (子类需实现)
  Future<Map<String, dynamic>> requestTokenRefresh(String refreshToken);

  /// 检查令牌是否过期
  bool _isTokenExpired(Account account) {
    final credential = account.credential;
    if (credential.expiresAt == null) return false;
    return credential.isExpired;
  }

  /// 检查令牌是否即将过期（5分钟内）
  bool _isTokenExpiringSoon(Account account) {
    final credential = account.credential;
    if (credential.expiresAt == null) return false;
    return credential.isExpiringSoon();
  }
}

/// 用户名密码凭据提供者
abstract class UserPasswordCredentialProvider extends CredentialProvider {
  @override
  Future<Account> getCredential(Account account) async {
    final username = account.username;
    final password = account.password;

    if (username == null || password == null) {
      throw CredentialExpiredException(account, '缺少用户名或密码');
    }

    // 验证凭据是否仍然有效
    final isValid = await validateCredential(account);
    if (!isValid) {
      throw CredentialExpiredException(account, '凭据已失效，请重新登录');
    }

    return account;
  }

  @override
  Future<Account> refreshCredential(Account account) async {
    // 用户名密码类型通常需要重新登录
    throw UnimplementedError('用户名密码凭据不支持自动刷新，请重新登录');
  }
}
