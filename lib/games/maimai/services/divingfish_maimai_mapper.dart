import 'package:rank_hub/games/maimai/models/enums/fc_type.dart';
import 'package:rank_hub/games/maimai/models/enums/fs_type.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/rate_type.dart';
import 'package:rank_hub/games/maimai/models/enums/song_type.dart';
import 'package:rank_hub/games/maimai/models/maimai_best50_data.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/divingfish/divingfish_score.dart';

class DivingFishMaimaiMapper {
  static MaimaiScore toMaimaiScore(
    DivingFishScore score, {
    MaimaiSong? song,
  }) {
    final songType = _mapSongType(score.type);
    final levelIndex = LevelIndex.fromValue(score.levelIndex);
    final difficulty = _findDifficulty(song, songType, levelIndex);
    final totalNotes = difficulty?.notes?.total ?? 0;
    final level = score.level.isNotEmpty ? score.level : (difficulty?.level ?? '');
    final songName = score.title.isNotEmpty ? score.title : (song?.title ?? '');

    return MaimaiScore(
      songId: score.songId,
      songName: songName,
      level: level,
      levelIndex: levelIndex,
      achievements: score.achievements,
      fc: FCType.fromValue(score.fc),
      fs: FSType.fromValue(score.fs),
      dxScore: score.dxScore,
      dxStar: _calculateDxStar(score.dxScore, totalNotes),
      dxRating: score.ra.toDouble(),
      rate: RateType.fromValue(score.rate),
      type: songType,
    );
  }

  static MaimaiPlayer toMaimaiPlayer(DivingFishPlayerData data) {
    final name = data.nickname.isNotEmpty ? data.nickname : data.username;
    return MaimaiPlayer(
      name: name,
      rating: data.rating,
      friendCode: 0,
      courseRank: 0,
      classRank: 0,
      star: 0,
      uploadTime: data.lastUpdated?.toIso8601String(),
    );
  }

  static MaimaiBest50Data buildBest50(List<MaimaiScore> scores) {
    final dxScores = scores.where((s) => s.type == SongType.dx).toList()
      ..sort((a, b) => b.dxRating.compareTo(a.dxRating));
    final standardScores =
        scores.where((s) => s.type == SongType.standard).toList()
          ..sort((a, b) => b.dxRating.compareTo(a.dxRating));

    final dxTop = dxScores.take(15).toList();
    final standardTop = standardScores.take(35).toList();

    final dxTotal = dxTop.fold<int>(
      0,
      (sum, score) => sum + score.dxRating.toInt(),
    );
    final standardTotal = standardTop.fold<int>(
      0,
      (sum, score) => sum + score.dxRating.toInt(),
    );

    return MaimaiBest50Data(
      dxScores: dxTop,
      standardScores: standardTop,
      dxTotal: dxTotal,
      standardTotal: standardTotal,
    );
  }

  static SongType _mapSongType(String raw) {
    return raw.toLowerCase() == 'dx' ? SongType.dx : SongType.standard;
  }

  static MaimaiSongDifficulty? _findDifficulty(
    MaimaiSong? song,
    SongType type,
    LevelIndex levelIndex,
  ) {
    if (song == null) return null;
    final list = type == SongType.dx ? song.difficulties.dx : song.difficulties.standard;
    if (list.isEmpty) return null;
    return list.firstWhere(
      (diff) => diff.difficulty == levelIndex,
      orElse: () => list.first,
    );
  }

  static int _calculateDxStar(int currentDxScore, int totalNotes) {
    if (totalNotes <= 0) return 0;
    final maxDxScore = totalNotes * 3;
    if (maxDxScore <= 0) return 0;
    final percentage = (currentDxScore / maxDxScore) * 100;
    if (percentage >= 97.0) return 5;
    if (percentage >= 95.0) return 4;
    if (percentage >= 93.0) return 3;
    if (percentage >= 90.0) return 2;
    if (percentage >= 85.0) return 1;
    return 0;
  }
}
