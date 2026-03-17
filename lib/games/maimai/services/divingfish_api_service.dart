import 'package:dio/dio.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/platforms/maimai/divingfish_credential_provider.dart';
import 'package:rank_hub/games/maimai/models/divingfish/divingfish_score.dart';

class MaimaiDivingFishApiService {
  static final MaimaiDivingFishApiService _instance =
      MaimaiDivingFishApiService._internal();
  factory MaimaiDivingFishApiService() => _instance;
  static MaimaiDivingFishApiService get instance => _instance;

  MaimaiDivingFishApiService._internal();

  static const String baseUrl = 'https://www.diving-fish.com/api';

  final Dio _publicDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  final MaimaiDivingFishCredentialProvider _credentialProvider =
      MaimaiDivingFishCredentialProvider();

  Future<Dio> _getAuthenticatedDio(Account account) async {
    await _credentialProvider.getCredential(account);
    return _credentialProvider.getDioWithCookies(account);
  }

  Future<
    ({DivingFishPlayerData playerData, List<DivingFishScore> scores})
  > getPlayerRecords({required Account account}) async {
    try {
      final dio = await _getAuthenticatedDio(account);
      final response = await dio.get('$baseUrl/maimaidxprober/player/records');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final playerData = DivingFishPlayerData.fromJson(data);
        final recordsJson = data['records'] as List<dynamic>? ?? [];
        final scores = recordsJson
            .whereType<Map<String, dynamic>>()
            .map(DivingFishScore.fromJson)
            .toList();

        return (playerData: playerData, scores: scores);
      } else if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map && data['message'] != null) {
          throw Exception(data['message']);
        }
        throw Exception('获取成绩失败');
      } else {
        throw Exception('获取成绩失败: ${response.statusCode}');
      }
    } catch (e) {
      CoreLogService.e(
        '获取水鱼成绩失败: $e',
        scope: 'MAIMAI',
        platform: 'DIVINGFISH',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> queryPlayer({
    required String username,
    int? b50 = 1,
  }) async {
    try {
      final response = await _publicDio.post(
        '/maimaidxprober/query/player',
        data: {'username': username, 'b50': b50},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map && data['message'] != null) {
          throw Exception(data['message']);
        }
        throw Exception('查询玩家失败');
      } else {
        throw Exception('查询玩家失败: ${response.statusCode}');
      }
    } catch (e) {
      CoreLogService.e(
        '查询水鱼玩家失败: $e',
        scope: 'MAIMAI',
        platform: 'DIVINGFISH',
      );
      rethrow;
    }
  }
}
