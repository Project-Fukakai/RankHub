import 'package:flutter/material.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/games/maimai/views/divingfish_login_page.dart';
import 'package:rank_hub/platforms/maimai/divingfish_credential_provider.dart';

class DivingFishLoginHandler extends PlatformLoginHandler {
  final MaimaiDivingFishCredentialProvider _credentialProvider =
      MaimaiDivingFishCredentialProvider();

  @override
  PlatformId get platformId => const PlatformId('divingfish');

  @override
  String get platformName => '水鱼查分器';

  @override
  IconData get platformIcon => Icons.water_drop_outlined;

  @override
  String? get platformIconUrl => 'https://www.diving-fish.com/favicon.ico';

  @override
  String get platformDescription => '水鱼查分器账号登录';

  @override
  Future<PlatformLoginResult?> showLoginPage(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DivingFishLoginPage()),
    );
  }

  @override
  Future<bool> validateCredentials(Map<String, dynamic> credentialData) async {
    final username = credentialData['username'] as String?;
    final password = credentialData['password'] as String?;
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      return false;
    }

    final account = Account(
      platformId: 'divingfish',
      credentials: {},
      metadata: {
        'username': username,
        'password': password,
      },
    );

    return _credentialProvider.validateCredential(account);
  }

  @override
  Future<PlatformAccountInfo?> fetchAccountInfo(
    Map<String, dynamic> credentialData,
  ) async {
    final username = credentialData['username'] as String?;
    if (username == null || username.isEmpty) {
      return null;
    }
    return PlatformAccountInfo(
      externalId: username,
      displayName: username,
    );
  }
}
