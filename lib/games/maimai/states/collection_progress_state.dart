import 'package:flutter/foundation.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';

/// 单曲完成度信息
@immutable
class SongProgress {
  final int songId;
  final String title;
  final String type;
  final List<LevelIndex> requiredDifficulties;
  final List<LevelIndex> completedDifficulties;
  final bool isCompleted;
  final MaimaiSong? songDetail;

  const SongProgress({
    required this.songId,
    required this.title,
    required this.type,
    required this.requiredDifficulties,
    required this.completedDifficulties,
    required this.isCompleted,
    this.songDetail,
  });
}

/// 藏品完成度信息
@immutable
class CollectionProgress {
  final MaimaiCollection collection;
  final int totalCharts;
  final int completedCharts;
  final Map<LevelIndex, int> completedByDifficulty;
  final Map<LevelIndex, int> totalByDifficulty;
  final List<SongProgress> songProgresses;
  final bool isPinned;
  final List<MaimaiVersion> versions;

  const CollectionProgress({
    required this.collection,
    required this.totalCharts,
    required this.completedCharts,
    required this.completedByDifficulty,
    required this.totalByDifficulty,
    required this.songProgresses,
    this.isPinned = false,
    this.versions = const [],
  });

  double get progress => totalCharts > 0 ? completedCharts / totalCharts : 0.0;

  double getProgressByDifficulty(LevelIndex difficulty) {
    final total = totalByDifficulty[difficulty] ?? 0;
    final completed = completedByDifficulty[difficulty] ?? 0;
    return total > 0 ? completed / total : 0.0;
  }

  CollectionProgress copyWith({
    MaimaiCollection? collection,
    int? totalCharts,
    int? completedCharts,
    Map<LevelIndex, int>? completedByDifficulty,
    Map<LevelIndex, int>? totalByDifficulty,
    List<SongProgress>? songProgresses,
    bool? isPinned,
    List<MaimaiVersion>? versions,
  }) {
    return CollectionProgress(
      collection: collection ?? this.collection,
      totalCharts: totalCharts ?? this.totalCharts,
      completedCharts: completedCharts ?? this.completedCharts,
      completedByDifficulty:
          completedByDifficulty ?? this.completedByDifficulty,
      totalByDifficulty: totalByDifficulty ?? this.totalByDifficulty,
      songProgresses: songProgresses ?? this.songProgresses,
      isPinned: isPinned ?? this.isPinned,
      versions: versions ?? this.versions,
    );
  }
}

/// 收藏品进度追踪状态
@immutable
class CollectionProgressState {
  final List<MaimaiCollection> allCollectionsWithSongs;
  final MaimaiCollection? selectedCollection;
  final CollectionProgress? currentProgress;
  final List<CollectionProgress> pinnedProgresses;
  final bool isLoading;
  final String? errorMessage;

  const CollectionProgressState({
    this.allCollectionsWithSongs = const [],
    this.selectedCollection,
    this.currentProgress,
    this.pinnedProgresses = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CollectionProgressState copyWith({
    List<MaimaiCollection>? allCollectionsWithSongs,
    MaimaiCollection? selectedCollection,
    CollectionProgress? currentProgress,
    List<CollectionProgress>? pinnedProgresses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CollectionProgressState(
      allCollectionsWithSongs:
          allCollectionsWithSongs ?? this.allCollectionsWithSongs,
      selectedCollection: selectedCollection ?? this.selectedCollection,
      currentProgress: currentProgress ?? this.currentProgress,
      pinnedProgresses: pinnedProgresses ?? this.pinnedProgresses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
