import 'package:flutter/foundation.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';

/// 随机选曲状态
@immutable
class RandomPickerState {
  final bool isLoading;
  final List<MaimaiSong> randomSongs;

  // 筛选条件
  final List<LevelIndex> selectedDifficulties;
  final List<int> selectedVersionIds;
  final List<String> selectedGenres;
  final double minLevel;
  final double maxLevel;
  final String chartType; // 'all', 'standard', 'dx'
  final int pickCount;

  // 数据源
  final List<MaimaiVersion> versions;
  final List<String> genres;

  const RandomPickerState({
    this.isLoading = false,
    this.randomSongs = const [],
    this.selectedDifficulties = const [],
    this.selectedVersionIds = const [],
    this.selectedGenres = const [],
    this.minLevel = 1.0,
    this.maxLevel = 15.0,
    this.chartType = 'all',
    this.pickCount = 1,
    this.versions = const [],
    this.genres = const [],
  });

  RandomPickerState copyWith({
    bool? isLoading,
    List<MaimaiSong>? randomSongs,
    List<LevelIndex>? selectedDifficulties,
    List<int>? selectedVersionIds,
    List<String>? selectedGenres,
    double? minLevel,
    double? maxLevel,
    String? chartType,
    int? pickCount,
    List<MaimaiVersion>? versions,
    List<String>? genres,
  }) {
    return RandomPickerState(
      isLoading: isLoading ?? this.isLoading,
      randomSongs: randomSongs ?? this.randomSongs,
      selectedDifficulties: selectedDifficulties ?? this.selectedDifficulties,
      selectedVersionIds: selectedVersionIds ?? this.selectedVersionIds,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      minLevel: minLevel ?? this.minLevel,
      maxLevel: maxLevel ?? this.maxLevel,
      chartType: chartType ?? this.chartType,
      pickCount: pickCount ?? this.pickCount,
      versions: versions ?? this.versions,
      genres: genres ?? this.genres,
    );
  }
}
