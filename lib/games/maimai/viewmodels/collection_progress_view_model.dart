import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/repositories/maimai_collection_repository.dart';
import 'package:rank_hub/games/maimai/states/collection_progress_state.dart';
import 'package:rank_hub/games/maimai/viewmodels/maimai_score_view_model.dart';

/// 收藏品进度追踪 ViewModel
/// 管理收藏品完成度的计算和固定列表
class CollectionProgressViewModel extends Notifier<CollectionProgressState> {
  late final MaimaiCollectionRepository _collectionRepo;
  final Map<int, MaimaiSong> _songsById = {};
  final Map<int, List<MaimaiScore>> _scoresBySongId = {};
  List<MaimaiVersion> _versions = [];

  @override
  CollectionProgressState build() {
    _collectionRepo = MaimaiCollectionRepository();

    // 监听成绩变化以自动刷新进度
    ref.listen(maimaiScoreViewModelProvider, (previous, next) {
      if (previous?.allScores != next.allScores) {
        refreshCurrentProgress();
      }
    });

    // 自动加载数据
    Future.microtask(() => loadCollections());

    return const CollectionProgressState(isLoading: true);
  }

  /// 加载所有有曲目要求的收藏品
  Future<void> loadCollections() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final allCollections = await ref.read(
        resourceProviderOf<List<MaimaiCollection>>(
          maimaiCollectionListResourceKey,
        ).future,
      );

      // 筛选出有曲目要求的收藏品
      final collectionsWithSongs = allCollections.where((collection) {
        return collection.required.any((req) => req.songs.isNotEmpty);
      }).toList();

      state = state.copyWith(
        allCollectionsWithSongs: collectionsWithSongs,
        isLoading: false,
      );

      await _loadSupportingData();

      // 加载固定的收藏品
      await loadPinnedCollections();
    } catch (e) {
      CoreLogService.e(
        '加载收藏品失败: $e',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      state = state.copyWith(isLoading: false, errorMessage: '加载收藏品失败: $e');
    }
  }

  /// 加载固定的收藏品及其完成度
  Future<void> loadPinnedCollections() async {
    final pinned = await _collectionRepo.getPinnedCollections();
    final progressList = <CollectionProgress>[];

    for (final pinnedItem in pinned) {
      final collection = _findCollection(
        pinnedItem.collectionType,
        pinnedItem.collectionId,
      );
      if (collection == null) continue;
      final progress = await calculateProgress(collection);
      progressList.add(progress.copyWith(isPinned: true));
    }

    state = state.copyWith(pinnedProgresses: progressList);
  }

  /// 计算收藏品完成度
  Future<CollectionProgress> calculateProgress(
    MaimaiCollection collection,
  ) async {
    final songProgresses = <SongProgress>[];
    int totalCharts = 0;
    int completedCharts = 0;
    final completedByDifficulty = <LevelIndex, int>{};
    final totalByDifficulty = <LevelIndex, int>{};
    final songVersionNumbers = <int>{};

    // 遍历所有要求
    for (final req in collection.required) {
      if (req.songs.isEmpty) continue;

      for (final reqSong in req.songs) {
        final songDetail = _songsById[reqSong.id];

        if (songDetail != null) {
          songVersionNumbers.add(songDetail.version);
        }

        final scores = _scoresBySongId[reqSong.id] ?? const <MaimaiScore>[];

        final completedDiffs = <LevelIndex>[];
        for (final diff in req.difficulties) {
          totalCharts++;
          totalByDifficulty[diff] = (totalByDifficulty[diff] ?? 0) + 1;

          final hasScore = scores.any(
            (score) =>
                score.levelIndex == diff && _meetsRequirement(score, req),
          );

          if (hasScore) {
            completedDiffs.add(diff);
            completedCharts++;
            completedByDifficulty[diff] =
                (completedByDifficulty[diff] ?? 0) + 1;
          }
        }

        final isCompleted = req.difficulties.every(
          (diff) => completedDiffs.contains(diff),
        );

        songProgresses.add(
          SongProgress(
            songId: reqSong.id,
            title: reqSong.title,
            type: reqSong.type.name,
            requiredDifficulties: req.difficulties,
            completedDifficulties: completedDiffs,
            isCompleted: isCompleted,
            songDetail: songDetail,
          ),
        );
      }
    }

    // 获取所有涉及的版本信息
    final versions = await _getVersionsForSongs(songVersionNumbers);

    return CollectionProgress(
      collection: collection,
      totalCharts: totalCharts,
      completedCharts: completedCharts,
      completedByDifficulty: completedByDifficulty,
      totalByDifficulty: totalByDifficulty,
      songProgresses: songProgresses,
      versions: versions,
    );
  }

  /// 获取曲目涉及的版本信息
  Future<List<MaimaiVersion>> _getVersionsForSongs(Set<int> versionNumbers) async {
    if (versionNumbers.isEmpty) return [];

    try {
      final allVersions = _versions;
      allVersions.sort((a, b) => b.version.compareTo(a.version));

      final versionMap = <int, MaimaiVersion>{};

      for (final versionNumber in versionNumbers) {
        MaimaiVersion? matchedVersion;

        if (allVersions.isNotEmpty) {
          if (versionNumber >= allVersions.first.version) {
            matchedVersion = allVersions.first;
          } else if (versionNumber < allVersions.last.version) {
            matchedVersion = allVersions.last;
          } else {
            for (int i = 0; i < allVersions.length - 1; i++) {
              final currentVersion = allVersions[i];
              final nextVersion = allVersions[i + 1];
              if (versionNumber >= nextVersion.version &&
                  versionNumber < currentVersion.version) {
                matchedVersion = nextVersion;
                break;
              }
            }
          }
        }

        if (matchedVersion != null) {
          versionMap[matchedVersion.versionId] = matchedVersion;
        }
      }

      return versionMap.values.toList()
        ..sort((a, b) => b.version.compareTo(a.version));
    } catch (e) {
      CoreLogService.w(
        '获取版本信息失败: $e',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      return [];
    }
  }

  MaimaiCollection? _findCollection(String type, int id) {
    for (final collection in state.allCollectionsWithSongs) {
      if (collection.collectionType == type && collection.collectionId == id) {
        return collection;
      }
    }
    return null;
  }

  Future<void> _loadSupportingData() async {
    final songs = await ref.read(
      resourceProviderOf<List<MaimaiSong>>(maimaiSongListResourceKey).future,
    );
    final scores = await ref.read(
      resourceProviderOf<List<MaimaiScore>>(maimaiScoreListResourceKey).future,
    );
    final versions = await ref.read(
      resourceProviderOf<List<MaimaiVersion>>(maimaiVersionListResourceKey)
          .future,
    );

    _songsById
      ..clear()
      ..addEntries(songs.map((song) => MapEntry(song.songId, song)));

    _scoresBySongId.clear();
    for (final score in scores) {
      _scoresBySongId.putIfAbsent(score.songId, () => []).add(score);
    }

    _versions = versions;
  }

  /// 判断成绩是否满足要求
  bool _meetsRequirement(MaimaiScore score, MaimaiCollectionRequired req) {
    if (req.rate != null && (score.rate?.index ?? 999) > req.rate!.index) {
      return false;
    }

    if (req.fc != null && (score.fc?.index ?? 999) > req.fc!.index) {
      return false;
    }

    if (req.fs != null && (score.fs?.index ?? 999) > req.fs!.index) {
      return false;
    }

    return true;
  }

  /// 选择收藏品查看详情
  Future<void> selectCollection(MaimaiCollection collection) async {
    state = state.copyWith(selectedCollection: collection, isLoading: true);

    try {
      final progress = await calculateProgress(collection);
      state = state.copyWith(currentProgress: progress, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '计算进度失败: $e');
    }
  }

  /// 固定/取消固定收藏品
  Future<void> togglePin(MaimaiCollection collection) async {
    final isPinned = await _collectionRepo.isCollectionPinned(
      collection.collectionId,
      collection.collectionType,
    );

    if (isPinned) {
      await _collectionRepo.unpinCollection(
        collection.collectionId,
        collection.collectionType,
      );
    } else {
      await _collectionRepo.pinCollection(
        collection.collectionId,
        collection.collectionType,
      );
    }

    await loadPinnedCollections();
  }

  /// 刷新当前收藏品的完成度
  Future<void> refreshCurrentProgress() async {
    if (state.selectedCollection != null) {
      await selectCollection(state.selectedCollection!);
    }
    await loadPinnedCollections();
  }
}

/// Provider for CollectionProgressViewModel
final collectionProgressViewModelProvider =
    NotifierProvider<CollectionProgressViewModel, CollectionProgressState>(
      () => CollectionProgressViewModel(),
    );
