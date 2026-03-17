import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/song_type.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';

/// Maimai 成绩数据仓库
/// 封装成绩相关的数据访问逻辑，需要账号凭据
class MaimaiScoreRepository {
  final MaimaiIsarService _isarService;
  final LxnsApiService _apiService;

  MaimaiScoreRepository({
    MaimaiIsarService? isarService,
    LxnsApiService? apiService,
  }) : _isarService = isarService ?? MaimaiIsarService.instance,
       _apiService = apiService ?? LxnsApiService.instance;

  /// 获取所有成绩（按 DX Rating 降序）
  /// [account] 当前账号
  /// [forceRefresh] 是否强制从 API 刷新
  Future<List<MaimaiScore>> getAllScores({
    required Account account,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      await _syncScoresFromApi(account);
      return await _isarService.getAllScoresSortedByRating();
    }

    final dbScores = await _isarService.getAllScoresSortedByRating();
    if (dbScores.isNotEmpty) {
      return dbScores;
    }

    await _syncScoresFromApi(account);
    return await _isarService.getAllScoresSortedByRating();
  }

  /// 获取 Best 50 成绩
  Future<List<MaimaiScore>> getBest50Scores() async {
    return await _isarService.getBest50Scores();
  }

  /// 根据曲目 ID 获取成绩
  Future<List<MaimaiScore>> getScoresBySongId(int songId) async {
    return await _isarService.getScoresBySongId(songId);
  }

  /// 根据曲目ID、难度和类型获取成绩
  Future<MaimaiScore?> getScoreBySongIdAndDifficulty({
    required int songId,
    required LevelIndex levelIndex,
    required SongType type,
  }) async {
    return await _isarService.getScoreBySongIdAndDifficulty(
      songId: songId,
      levelIndex: levelIndex,
      type: type,
    );
  }

  /// 检查是否有缓存数据
  Future<bool> hasCachedData() async {
    final scores = await _isarService.getAllScoresSortedByRating();
    return scores.isNotEmpty;
  }

  /// 从 API 同步成绩
  Future<void> _syncScoresFromApi(Account account) async {
    final provider = CoreProvider.instance.getCredentialProvider(account.platformId);
    String? accessToken = account.accessToken;

    if (provider != null) {
      try {
        final validAccount = await provider.getCredential(account);
        accessToken = validAccount.accessToken;
      } catch (e) {
        CoreLogService.e(
          'Refresh token failed: $e',
          scope: 'MAIMAI',
          platform: 'LXNS',
        );
      }
    }

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('账号未授权或令牌已失效，请重新登录');
    }

    await _apiService.syncPlayerScoresToDatabase(accessToken: accessToken);
  }

  /// 同步数据到数据库（带进度回调）
  Future<void> syncFromApi({
    required Account account,
    void Function(int current, int total, String description)? onProgress,
  }) async {
    final provider = CoreProvider.instance.getCredentialProvider(account.platformId);
    String? accessToken = account.accessToken;

    if (provider != null) {
      try {
        final validAccount = await provider.getCredential(account);
        accessToken = validAccount.accessToken;
      } catch (e) {
        CoreLogService.e(
          'Refresh token failed: $e',
          scope: 'MAIMAI',
          platform: 'LXNS',
        );
      }
    }

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('账号未授权或令牌已失效，请重新登录');
    }

    await _apiService.syncPlayerScoresToDatabase(
      accessToken: accessToken,
      onProgress: onProgress,
    );
  }
}
