import 'package:dio/dio.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_response.dart';

class LxnsPlatform {
  static final LxnsPlatform instance = LxnsPlatform._();
  LxnsPlatform._();

  final Dio _dio = Dio();

  // OAuth2 Configuration
  static const String baseUrl = 'https://maimai.lxns.net';
  static const String clientId = 'd7a8e3dc-0e08-43b1-ac08-7e4b2b4574bd';
  static const String redirectUri = 'https://rankhub.kamitsubaki.city/callback';
  static const String scope = 'read_user_profile read_player read_user_token write_player';
  
  static const String manualClientId = '2f8e94e4-1faf-4213-bfbc-0aaf55e71a86';
  static const String manualRedirectUri = 'urn:ietf:wg:oauth:2.0:oob';

  // Helper methods for login logic

  Future<Map<String, dynamic>?> exchangeCodeForToken(String code, String codeVerifier) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v0/oauth/token',
        data: {
          'client_id': clientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'code_verifier': codeVerifier,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final apiResponse = LxnsApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          dataParser: (data) => data as Map<String, dynamic>,
        );

        if (apiResponse.success && apiResponse.data != null) {
          final data = apiResponse.data!;
          return {
            'access_token': data['access_token'],
            'refresh_token': data['refresh_token'],
            'token_expiry': DateTime.now()
                .add(Duration(seconds: data['expires_in'] as int))
                .toIso8601String(),
            'scope': data['scope'],
          };
        }
      }
    } catch (e) {
      CoreLogService.e(
        'Exchange token failed: $e',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
    }
    return null;
  }

  Future<Map<String, dynamic>?> exchangeCodeForTokenManual(String code, String codeVerifier) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v0/oauth/token',
        data: {
          'client_id': manualClientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': manualRedirectUri,
          'code_verifier': codeVerifier,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final apiResponse = LxnsApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          dataParser: (data) => data as Map<String, dynamic>,
        );

        if (apiResponse.success && apiResponse.data != null) {
          final data = apiResponse.data!;
          return {
            'access_token': data['access_token'],
            'refresh_token': data['refresh_token'],
            'token_expiry': DateTime.now()
                .add(Duration(seconds: data['expires_in'] as int))
                .toIso8601String(),
            'scope': data['scope'],
          };
        }
      }
    } catch (e) {
      CoreLogService.e(
        'Exchange token manual failed: $e',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
    }
    return null;
  }

  Future<Map<String, dynamic>?> refreshCredentials(String refreshToken) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v0/oauth/token',
        data: {
          'client_id': clientId,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        final apiResponse = LxnsApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          dataParser: (data) => data as Map<String, dynamic>,
        );

        if (apiResponse.success && apiResponse.data != null) {
          final data = apiResponse.data!;
          return {
            'access_token': data['access_token'],
            'refresh_token': data['refresh_token'],
            'token_expiry': DateTime.now()
                .add(Duration(seconds: data['expires_in'] as int))
                .toIso8601String(),
          };
        }
      }
    } catch (e) {
      CoreLogService.e(
        'Refresh token failed: $e',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchAccountInfo(String accessToken) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/v0/user/profile',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final apiResponse = LxnsApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          dataParser: (data) => data as Map<String, dynamic>,
        );

        if (apiResponse.success && apiResponse.data != null) {
          return apiResponse.data!;
        }
      }
    } catch (e) {
      CoreLogService.e(
        'Fetch account info failed: $e',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
    }
    return null;
  }
}
