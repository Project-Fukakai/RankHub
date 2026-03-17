import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/credential.dart';
import 'package:rank_hub/core/credential_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/games/phigros/services/phigros_api_service.dart';

class PhigrosCredentialProvider extends ApiKeyCredentialProvider {
  final PhigrosApiService _apiService = PhigrosApiService.instance;

  @override
  PlatformId get platformId => const PlatformId('phigros');

  @override
  Future<bool> validateCredential(Account account) async {
    if (account.apiKey == null || account.apiKey!.isEmpty) {
      return false;
    }

    try {
      // 通过请求用户信息来验证 Session Token 是否有效
      await _apiService.getUserInfo(account.apiKey!);
      return true;
    } catch (e) {
      print('验证凭据失败: $e');
      return false;
    }
  }

  @override
  Future<void> createCredential(
    Account account,
    Map<String, dynamic> credentialData,
  ) async {
    final credential = ApiKeyCredential(
      apiKey: credentialData['api_key'] as String? ?? '',
    );

    account.credentials
      ..clear()
      ..addAll(credential.toJson())
      ..['credential_created_at'] = DateTime.now().toIso8601String();

    if (credentialData['external_id'] != null) {
      account.metadata['external_id'] = credentialData['external_id'];
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
    account.credentials.clear();
  }
}
