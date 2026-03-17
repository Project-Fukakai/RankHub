import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/models/net_score.dart';

/// Maimai DX NET API 服务
/// 使用 techno_kitchen_dart 与 NET 通信
class MaimaiNetApiService {
  static final MaimaiNetApiService _instance = MaimaiNetApiService._internal();
  factory MaimaiNetApiService() => _instance;
  static MaimaiNetApiService get instance => _instance;

  late final Config _config;
  late final RequestAdapter _requestAdapter;
  late final ArcadeInfo _arcadeInfo;

  MaimaiNetApiService._internal() {
    _requestAdapter = RequestAdapter(
      aesKey: const String.fromEnvironment(
        'MAIMAI_NET_API_AES_KEY',
        defaultValue: 'SBGA',
      ),
      aesIv: const String.fromEnvironment(
        'MAIMAI_NET_API_AES_IV',
        defaultValue: 'SBGA',
      ),
      obfuscateParam: const String.fromEnvironment(
        'MAIMAI_NET_API_OBFUSCATE_PARAM',
        defaultValue: 'SBGA',
      ),
      keychipID: const String.fromEnvironment(
        'MAIMAI_NET_API_KEYCHIP_ID',
        defaultValue: 'SBGA',
      ),
      salt: const String.fromEnvironment(
        'MAIMAI_NET_API_SALT',
        defaultValue: 'SBGA',
      ),
      openGameID: const String.fromEnvironment(
        'MAIMAI_NET_API_OPEN_GAME_ID',
        defaultValue: 'SBGA',
      ),
      maiEncoding: const String.fromEnvironment(
        'MAIMAI_NET_API_MAI_ENCODING',
        defaultValue: 'SBGA',
      ),
      chimeEndpoint: const String.fromEnvironment(
        'MAIMAI_NET_API_CHIME_ENDPOINT',
        defaultValue: 'SBGA',
      ),
      titleEndpoint: const String.fromEnvironment(
        'MAIMAI_NET_API_TITLE_ENDPOINT',
        defaultValue: 'SBGA',
      ),
    );

    _arcadeInfo = ArcadeInfo.defaultInfo();

    _config = Config(
      requestAdapter: _requestAdapter,
      arcadeInfo: _arcadeInfo,
      musicData: MusicData.defaultData(),
    );

    debugPrint(_requestAdapter.toString());
  }

  Config get config => _config;

  /// 从QR Code创建用户会话
  /// [qrCode] 二维码内容，格式: SGWCMAID<16-digit timestamp YYMMDDHHMMSS><64-character QR code>
  UserSession createSessionFromQrCode(String qrCode) {
    return UserSession(qrCode, _config);
  }

  /// 从URL创建用户会话
  /// [url] 二维码URL，格式: https://wq.waleak.net/qrcode/req/MAID...
  UserSession createSessionFromUrl(String url) {
    return UserSession.fromUrl(url, config: _config);
  }

  /// 获取用户预览信息（必须使用 QR Code）
  /// [qrCode] QR Code，格式: SGWCMAID<16-digit timestamp><64-character code>
  /// 返回用户基本信息，包括用户名、Rating等
  Future<UserPreview> getUserPreview(String qrCode) async {
    UserSession? session;
    try {
      // 使用 QR Code 创建会话并获取预览
      session = createSessionFromQrCode(qrCode);
      await session.init(); // init 后会获取 token
      final preview = await session.getUserPreview();
      return preview;
    } catch (e) {
      throw Exception('获取用户预览失败: $e');
    }
  }

  /// 初始化并登录会话
  /// [session] 用户会话
  Future<void> initAndLogin(UserSession session) async {
    try {
      await session.init();
      await session.login();
    } catch (e) {
      throw Exception('初始化或登录失败: $e');
    }
  }

  /// 获取用户详细数据
  /// [session] 已登录的用户会话
  Future<PlayerData> getUserData(UserSession session) async {
    try {
      final userData = await session.getUserData();
      return userData;
    } catch (e) {
      throw Exception('获取用户数据失败: $e');
    }
  }

  /// 获取用户音乐成绩
  /// [session] 已登录的用户会话
  /// [maxCount] 每次请求最大数量，默认2000
  /// [startIndex] 起始索引，默认0
  Future<NetScoreResponse> getUserMusic(
    UserSession session, {
    int maxCount = 2000,
    int startIndex = 0,
  }) async {
    try {
      final responseJson = await session.getUserMusic(
        nextIndex: startIndex,
        maxCount: maxCount,
      );

      final response = jsonDecode(responseJson) as Map<String, dynamic>;
      return NetScoreResponse.fromJson(response);
    } catch (e) {
      throw Exception('获取用户乐曲成绩失败: $e');
    }
  }

  /// 获取用户所有成绩（分页获取）
  /// [session] 已登录的用户会话
  /// [onProgress] 进度回调 (current, total, description)
  Future<List<NetScore>> getAllUserScores(
    UserSession session, {
    Function(int current, int total, String description)? onProgress,
  }) async {
    final allScores = <NetScore>[];
    int nextIndex = 0;
    int totalLength = 0;

    do {
      onProgress?.call(
        allScores.length,
        totalLength > 0 ? totalLength : allScores.length + 1,
        '正在获取成绩数据... (${allScores.length}/${totalLength > 0 ? totalLength : '?'})',
      );

      final response = await getUserMusic(
        session,
        maxCount: 2000,
        startIndex: nextIndex,
      );

      // 提取所有成绩
      for (final musicItem in response.userMusicList) {
        allScores.addAll(musicItem.userMusicDetailList);
      }

      nextIndex = response.nextIndex;

      // 更新总数估计
      if (totalLength == 0 && response.length > 0) {
        totalLength =
            allScores.length +
            (response.nextIndex > 0 ? response.length * 10 : 0);
      }

      // 如果 nextIndex 大于等于总长度，说明已经获取完毕
      if (nextIndex >= response.length || response.length == 0) {
        break;
      }
    } while (nextIndex > 0);

    onProgress?.call(allScores.length, allScores.length, '成绩获取完成！');

    return allScores;
  }

  /// 从QR Code获取NET用户信息（不保存）
  /// [qrCode] 二维码内容
  /// 返回完整的用户信息
  Future<PlayerData> getUserFromQrCode(String qrCode) async {
    UserSession? session;
    try {
      // 1. 创建会话
      session = createSessionFromQrCode(qrCode);

      // 2. 初始化并登录
      await initAndLogin(session);

      // 3. 获取用户数据
      final playerData = await getUserData(session);

      return playerData;
    } catch (e) {
      throw Exception('从QR Code获取用户失败: $e');
    } finally {
      // 5. 登出
      if (session != null && session.isLoggedIn) {
        try {
          await session.logout();
        } catch (e) {
          CoreLogService.w(
            '登出失败: $e',
            scope: 'MAIMAI',
            platform: 'MAIMAI_NET',
          );
        }
      }
    }
  }

  /// 登出会话
  Future<void> logout(UserSession session) async {
    try {
      await session.logout();
    } catch (e) {
      CoreLogService.w(
        '登出失败: $e',
        scope: 'MAIMAI',
        platform: 'MAIMAI_NET',
      );
    }
  }
}
