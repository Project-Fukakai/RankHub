import 'package:flutter/foundation.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';

/// Maimai 成绩状态
@immutable
class MaimaiScoreState {
  final List<MaimaiScore> allScores;
  final List<MaimaiScore> best50Scores;
  final DataLoadStatus loadStatus;
  final String? errorMessage;
  final bool isFromCache;

  // 统计数据
  final Map<String, int> fcStats;
  final Map<String, int> fsStats;

  const MaimaiScoreState({
    this.allScores = const [],
    this.best50Scores = const [],
    this.loadStatus = DataLoadStatus.idle,
    this.errorMessage,
    this.isFromCache = false,
    this.fcStats = const {},
    this.fsStats = const {},
  });

  MaimaiScoreState copyWith({
    List<MaimaiScore>? allScores,
    List<MaimaiScore>? best50Scores,
    DataLoadStatus? loadStatus,
    String? errorMessage,
    bool? isFromCache,
    Map<String, int>? fcStats,
    Map<String, int>? fsStats,
  }) {
    return MaimaiScoreState(
      allScores: allScores ?? this.allScores,
      best50Scores: best50Scores ?? this.best50Scores,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage,
      isFromCache: isFromCache ?? this.isFromCache,
      fcStats: fcStats ?? this.fcStats,
      fsStats: fsStats ?? this.fsStats,
    );
  }

  /// 根据曲目 ID 获取成绩
  List<MaimaiScore> getScoresBySongId(int songId) {
    return allScores.where((score) => score.songId == songId).toList();
  }

  /// 获取指定难度以上的成绩
  List<MaimaiScore> getScoresByMinLevel(double minLevel) {
    return allScores.where((score) {
      final levelStr = score.level.replaceAll('+', '');
      final levelValue = double.tryParse(levelStr) ?? 0;
      final actualLevel = score.level.contains('+')
          ? levelValue + 0.7
          : levelValue;
      return actualLevel >= minLevel;
    }).toList();
  }

  /// 获取指定评级的成绩
  List<MaimaiScore> getScoresByRate(String rateType) {
    return allScores.where((score) => score.rate?.name == rateType).toList();
  }

  /// 计算 FC/AP 统计
  static Map<String, int> calculateFcStats(List<MaimaiScore> scores) {
    final stats = <String, int>{};
    for (final score in scores) {
      if (score.fc != null) {
        final fcType = score.fc!.name;
        stats[fcType] = (stats[fcType] ?? 0) + 1;
      }
    }
    return stats;
  }

  /// 计算 FS 统计
  static Map<String, int> calculateFsStats(List<MaimaiScore> scores) {
    final stats = <String, int>{};
    for (final score in scores) {
      if (score.fs != null) {
        final fsType = score.fs!.name;
        stats[fsType] = (stats[fsType] ?? 0) + 1;
      }
    }
    return stats;
  }

  /// 计算 Best 50
  static List<MaimaiScore> calculateBest50(List<MaimaiScore> scores) {
    if (scores.length <= 50) {
      return scores;
    }
    return scores.take(50).toList();
  }
}
