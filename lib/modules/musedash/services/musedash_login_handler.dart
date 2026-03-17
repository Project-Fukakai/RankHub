import 'package:flutter/material.dart';
import 'package:rank_hub/models/account/account.dart';
import 'package:rank_hub/services/platform_login_handler.dart';
import 'package:rank_hub/modules/musedash/services/musedash_api_service.dart';
import 'package:rank_hub/modules/musedash/pages/musedash_bind_page.dart';

/// MuseDash.moe 登录处理器
class MuseDashLoginHandler extends PlatformLoginHandler {
  final _apiService = MuseDashApiService.instance;

  @override
  Platform get platform => Platform.musedash;

  @override
  String get platformName => 'MuseDash.moe';

  @override
  IconData get platformIcon => Icons.music_note_outlined;

  @override
  String? get platformIconUrl =>
      'https://musedash.moe/img/icons/android-chrome-512x512.png';

  @override
  String get platformDescription => 'Muse Dash 数据查询平台';

  @override
  bool get isSupported => true;

  @override
  Widget buildLoginPage(BuildContext context) {
    return const MuseDashBindPage();
  }

  @override
  Future<bool> validateCredentials(Map<String, dynamic> credentialData) async {
    if (!credentialData.containsKey('api_key')) {
      return false;
    }

    final uuid = credentialData['api_key'] as String;
    return await _apiService.validateUuid(uuid);
  }

  @override
  Future<PlatformAccountInfo?> fetchAccountInfo(
    Map<String, dynamic> credentialData,
  ) async {
    final uuid = credentialData['api_key'] as String;
    final playerInfo = await _apiService.getPlayerInfo(uuid);

    if (playerInfo == null) {
      return null;
    }

    return PlatformAccountInfo(
      externalId: uuid,
      displayName: playerInfo.nickname,
      metadata: playerInfo.toJson(),
    );
  }
}
