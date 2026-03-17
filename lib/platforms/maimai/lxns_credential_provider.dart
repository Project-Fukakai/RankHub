import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/credential_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/credential.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/platforms/maimai/lxns_platform.dart';

/// 落雪咖啡屋凭据提供者
/// 使用 OAuth2 + PKCE 授权，支持自动刷新 token
class LxnsCredentialProvider extends OAuth2CredentialProvider {
  
  @override
  PlatformId get platformId => const PlatformId('lxns');

  @override
  Future<bool> validateCredential(Account account) async {
    final accessToken = account.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    final info = await LxnsPlatform.instance.fetchAccountInfo(accessToken);
    return info != null;
  }

  @override
  Future<Map<String, dynamic>> requestTokenRefresh(String refreshToken) async {
    // 使用 refresh_token 获取新的访问令牌
    final newTokenData = await LxnsPlatform.instance.refreshCredentials(refreshToken);

    if (newTokenData == null) {
      throw Exception('刷新 token 失败');
    }

    // 返回标准格式的 token 数据
    final expiryTime = DateTime.parse(newTokenData['token_expiry'] as String);
    final expiresIn = expiryTime.difference(DateTime.now()).inSeconds;

    return {
      'access_token': newTokenData['access_token'],
      'refresh_token': newTokenData['refresh_token'],
      'expires_in': expiresIn,
    };
  }

  @override
  Future<void> createCredential(
    Account account,
    Map<String, dynamic> credentialData,
  ) async {
    DateTime? expiresAt;
    if (credentialData['token_expiry'] != null) {
      expiresAt = DateTime.tryParse(credentialData['token_expiry'] as String);
    } else if (credentialData['expires_at'] != null) {
      expiresAt = DateTime.tryParse(credentialData['expires_at'] as String);
    }
    final accessToken = credentialData['access_token'] as String? ??
        credentialData['token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw CredentialExpiredException(account, '缺少访问令牌');
    }
    final credential = JwtCredential(
      token: accessToken,
      refreshToken: credentialData['refresh_token'] as String?,
      expiresAt: expiresAt,
    );

    account.credentials
      ..clear()
      ..addAll(credential.toJson())
      ..['scope'] = credentialData['scope']
      ..['credential_created_at'] = DateTime.now().toIso8601String();

    if (credentialData['external_id'] != null) {
      account.metadata['external_id'] = credentialData['external_id'];
    }

    if (credentialData['username'] != null) {
      account.metadata['username'] = credentialData['username'];
    }

    if (credentialData['display_name'] != null) {
      account.metadata['display_name'] = credentialData['display_name'];
    }

    if (credentialData['avatar_url'] != null) {
      account.metadata['avatar_url'] = credentialData['avatar_url'];
    }
  }

  @override
  Future<void> revokeCredential(Account account) async {
    CoreLogService.i(
      '撤销凭据（本地清理）',
      scope: 'MAIMAI',
      platform: 'LXNS',
    );
    account.credentials.clear();
  }
}
