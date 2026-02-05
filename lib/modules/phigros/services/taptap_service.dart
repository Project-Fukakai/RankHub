import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class ShareClient {
  final Dio _dio;

  static const String clientId = 'rAK3FfdieFob2Nn8Am';

  ShareClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  final Map<String, String> tapHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'TapTapAndroidSDK/3.16.5',
  };

  final Map<String, String> phiHeaders = {
    'User-Agent': 'LeanCloud-CSharp-SDK/1.0.3',
    'X-LC-Id': 'rAK3FfdieFob2Nn8Am',
    'X-LC-Key': 'Qr9AEqtuoSVS3zeD6iVbM4ZC0AtkJcQ89tywVyi0',
    'Content-Type': 'application/json',
  };

  String generateMac(Map<String, dynamic> token) {
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final nonce = Random.secure().nextInt(0xFFFFFFFF);

    final input =
        '''
$ts
$nonce
GET
/account/basic-info/v1?client_id=$clientId
open.tapapis.cn
443

''';

    final hmacSha1 = Hmac(sha1, utf8.encode(token['mac_key']));
    final digest = hmacSha1.convert(utf8.encode(input));
    final macBase64 = base64.encode(digest.bytes);

    return 'MAC id="${token['kid']}",ts="$ts",nonce="$nonce",mac="$macBase64"';
  }

  /// 发起二维码登录，返回 device_code, expires_in 和 qrcode_url
  /// deviceId 为设备型号
  Future<Map<String, dynamic>> login(String deviceId) async {
    final resp = await _dio.post(
      'https://www.taptap.com/oauth2/v1/device/code',
      options: Options(headers: tapHeaders),
      data:
          'client_id=$clientId'
          '&response_type=device_code'
          '&scope=basic_info'
          '&version=1.2.0'
          '&platform=unity'
          '&info=${Uri.encodeComponent(jsonEncode({'device_id': deviceId}))}',
    );

    return resp.data['data'];
  }

  /// 轮询获取 token
  /// 返回 null 表示用户尚未完成扫码 (code: -1, error: "authorization_pending")
  /// 返回 Map 表示成功获取 token 数据
  /// 抛出异常表示其他错误
  Future<Map<String, dynamic>?> getToken(
    String deviceCode,
    String deviceId,
  ) async {
    final resp = await _dio.post(
      'https://www.taptap.cn/oauth2/v1/token',
      options: Options(headers: tapHeaders),
      data:
          'grant_type=device_token'
          '&client_id=$clientId'
          '&secret_type=hmac-sha-1'
          '&code=$deviceCode'
          '&version=1.0'
          '&platform=unity'
          '&info=${Uri.encodeComponent(jsonEncode({'device_id': deviceId}))}',
    );

    // 检查是否还在等待用户扫码
    if (resp.data['code'] == -1 &&
        resp.data['error'] == 'authorization_pending') {
      return null; // 用户尚未完成扫码授权
    }

    if (resp.data['success'] != true) {
      throw DioException(
        requestOptions: resp.requestOptions,
        response: resp,
        error: resp.data['data'],
      );
    }

    return resp.data['data'];
  }

  /// 获取 sessionToken
  /// 持续轮询直到用户完成二维码扫描授权
  ///
  /// [deviceCode] 从 login 方法获取的 device_code
  /// [deviceId] 设备型号
  /// [pollingInterval] 轮询间隔，默认 2 秒
  /// [timeout] 超时时间，默认 300 秒（5分钟）
  ///
  /// 返回 sessionToken 字符串
  Future<String> getSessionToken(
    String deviceCode,
    String deviceId, {
    Duration pollingInterval = const Duration(seconds: 2),
    Duration timeout = const Duration(seconds: 300),
  }) async {
    final startTime = DateTime.now();

    while (true) {
      // 检查是否超时
      if (DateTime.now().difference(startTime) > timeout) {
        throw TimeoutException('二维码登录超时，请重新尝试', timeout);
      }

      try {
        final tokenData = await getToken(deviceCode, deviceId);

        if (tokenData != null) {
          // 用户已完成扫码，注册用户获取 sessionToken
          final accountInfo = await getAccountInfo(tokenData);
          final sessionToken = await registerUser(tokenData, accountInfo);
          return sessionToken;
        }

        // 用户尚未完成扫码，等待后继续轮询
        await Future.delayed(pollingInterval);
      } catch (e) {
        // 如果是网络错误或其他异常，也等待后重试
        if (e is DioException) {
          await Future.delayed(pollingInterval);
        } else {
          rethrow;
        }
      }
    }
  }

  Future<Map<String, dynamic>> getAccountInfo(
    Map<String, dynamic> token,
  ) async {
    final auth = generateMac(token);

    final resp = await _dio.get<Map<String, dynamic>>(
      'https://open.tapapis.cn/account/basic-info/v1',
      queryParameters: {'client_id': clientId},
      options: Options(headers: {...tapHeaders, 'Authorization': auth}),
    );

    return resp.data!['data'];
  }

  Future<String> registerUser(
    Map<String, dynamic> token,
    Map<String, dynamic> account,
  ) async {
    final resp = await _dio.post(
      'https://rak3ffdi.cloud.tds1.tapapis.cn/1.1/users',
      options: Options(headers: phiHeaders),
      data: {
        'authData': {
          'taptap': {
            'kid': token['kid'],
            'access_token': token['kid'],
            'token_type': 'mac',
            'mac_key': token['mac_key'],
            'mac_algorithm': 'hmac-sha-1',
            'openid': account['openid'],
            'unionid': account['unionid'],
          },
        },
      },
    );

    // 返回 sessionToken
    return resp.data['sessionToken'] as String;
  }
}
