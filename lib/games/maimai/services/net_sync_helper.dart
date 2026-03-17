import 'package:rank_hub/games/maimai/models/net_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/song_type.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/core/services/core_log_service.dart';

/// NET 成绩同步辅助类
/// 提供统一的 NET 成绩转换和上传逻辑
class NetSyncHelper {
  NetSyncHelper._();

  /// 将 NET 成绩上传到 LXNS 查分器
  ///
  /// [netScores] 已获取的 NET 成绩
  /// [existingSongIds] 本地已存在的曲目 ID 集合
  /// [lxnsToken] LXNS 访问令牌
  /// [onProgress] 进度回调 (progress 0.0-1.0, message, count)
  ///
  /// 返回上传的成绩数量
  static Future<int> syncNetScoresToLxns({
    required List<NetScore> netScores,
    required Set<int> existingSongIds,
    required List<MaimaiSong> songs,
    required String lxnsToken,
    Function(double progress, String message, int count)? onProgress,
  }) async {
    try {
      // 1. 转换为 Score 对象 (0% - 40%)
      onProgress?.call(0.0, '正在转换成绩数据...', netScores.length);

      final songsById = {
        for (final song in songs) song.songId: song,
      };
      final allScores = await _convertNetScoresToScores(
        netScores,
        songsById,
      );

      // 2. 过滤本地不存在的乐曲 (40% - 60%)
      onProgress?.call(0.4, '正在验证乐曲数据...', allScores.length);

      final scores = _filterExistingSongs(allScores, existingSongIds);

      final filteredCount = allScores.length - scores.length;
      if (filteredCount > 0) {
        CoreLogService.w(
          '已过滤 $filteredCount 条本地不存在的乐曲成绩',
          scope: 'MAIMAI',
          platform: 'MAIMAI_NET',
        );
      }

      // 3. 上传到 LXNS 查分器 (60% - 100%)
      onProgress?.call(0.6, '正在上传到查分器... (${scores.length}条成绩)', scores.length);

      await LxnsApiService.instance.uploadScoresToLxns(
        accessToken: lxnsToken,
        scores: scores,
        onProgress: (current, total, description) {
          final progress = total > 0 ? 0.6 + (current / total * 0.4) : 0.6;
          onProgress?.call(progress, description, scores.length);
        },
      );

      onProgress?.call(1.0, '同步完成！', scores.length);

      return scores.length;
    } catch (e) {
      rethrow;
    }
  }

  /// 将 NET 成绩转换为标准 Score 对象
  ///
  /// 根据乐曲 ID 判断谱面类型：
  /// - ID > 10000: DX 谱面，songId 需要对 10000 取模
  /// - ID <= 10000: 标准谱面
  static Future<List<MaimaiScore>> _convertNetScoresToScores(
    List<NetScore> netScores,
    Map<int, MaimaiSong> songsById,
  ) async {
    final scores = <MaimaiScore>[];

    for (final netScore in netScores) {
      if (netScore.achievement > 0) {
        final isDxType = netScore.musicId > 10000;
        final songType = isDxType ? SongType.dx : SongType.standard;
        final actualSongId = isDxType ? netScore.musicId - 10000 : netScore.musicId;

        final song = songsById[actualSongId];
        final levelIndex = LevelIndex.fromValue(netScore.level);
        final difficultyList = isDxType
            ? song?.difficulties.dx
            : song?.difficulties.standard;
        final difficulty =
            (difficultyList == null || difficultyList.isEmpty)
                ? null
                : difficultyList.firstWhere(
                  (diff) => diff.difficulty == levelIndex,
                  orElse: () => difficultyList.first,
                );

        final baseScore = netScore.toScore(
          type: songType,
          songName: song?.title ?? '',
          levelStr: difficulty?.level ?? '',
          levelValue: difficulty?.levelValue,
          totalNotes: difficulty?.notes?.total,
        );

        final score = isDxType
            ? MaimaiScore(
                songId: actualSongId,
                songName: baseScore.songName,
                level: baseScore.level,
                levelIndex: baseScore.levelIndex,
                achievements: baseScore.achievements,
                fc: baseScore.fc,
                fs: baseScore.fs,
                dxScore: baseScore.dxScore,
                dxStar: baseScore.dxStar,
                dxRating: baseScore.dxRating,
                rate: baseScore.rate,
                type: baseScore.type,
                playTime: baseScore.playTime,
                uploadTime: baseScore.uploadTime,
                lastPlayedTime: baseScore.lastPlayedTime,
              )
            : baseScore;

        scores.add(score);
      }
    }

    return scores;
  }

  /// 过滤本地数据库中不存在的乐曲
  static List<MaimaiScore> _filterExistingSongs(
    List<MaimaiScore> scores,
    Set<int> existingSongIds,
  ) {
    final validScores = <MaimaiScore>[];

    for (final score in scores) {
      if (existingSongIds.contains(score.songId)) {
        validScores.add(score);
      } else {
        CoreLogService.w(
          '跳过不存在的乐曲: ID=${score.songId}, Type=${score.type.value}',
          scope: 'MAIMAI',
          platform: 'MAIMAI_NET',
        );
      }
    }

    return validScores;
  }
}
