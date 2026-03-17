import 'package:flutter/material.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/games/maimai/views/lxns_login_page.dart';
import 'package:rank_hub/platforms/maimai/lxns_platform.dart';

class LxnsLoginHandler extends PlatformLoginHandler {
  @override
  PlatformId get platformId => const PlatformId('lxns');

  @override
  String get platformName => '落雪咖啡屋';

  @override
  IconData get platformIcon => Icons.local_cafe_outlined;

  @override
  String? get platformIconUrl => 'https://maimai.lxns.net/favicon.webp';

  @override
  String get platformDescription => '落雪咖啡屋账号登录';

  @override
  Future<PlatformLoginResult?> showLoginPage(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LxnsLoginPage()),
    );
  }

  @override
  Future<bool> validateCredentials(Map<String, dynamic> credentialData) async {
    final accessToken = credentialData['token'] as String? ??
        credentialData['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    final info = await LxnsPlatform.instance.fetchAccountInfo(accessToken);
    return info != null;
  }

  @override
  Future<PlatformAccountInfo?> fetchAccountInfo(
    Map<String, dynamic> credentialData,
  ) async {
    final accessToken = credentialData['token'] as String? ??
        credentialData['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final info = await LxnsPlatform.instance.fetchAccountInfo(accessToken);
    if (info == null) return null;

    return PlatformAccountInfo(
      externalId: info['id'].toString(),
      displayName: info['name']?.toString(),
      avatarUrl: info['avatar']?.toString(),
      metadata: info.toString(),
    );
  }
}
