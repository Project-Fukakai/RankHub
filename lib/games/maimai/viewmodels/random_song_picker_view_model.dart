import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/states/random_picker_state.dart';

/// 随机选曲 ViewModel
/// 管理随机选曲的筛选条件和结果
class RandomSongPickerViewModel extends Notifier<RandomPickerState> {
  final _random = Random();
  List<MaimaiSong> _allSongs = [];

  @override
  RandomPickerState build() {
    // 自动加载数据
    Future.microtask(() => _loadData());

    return const RandomPickerState();
  }

  /// 加载数据
  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true);

    try {
      // 加载所有曲目
      final songs = await ref.read(
        resourceProviderOf<List<MaimaiSong>>(maimaiSongListResourceKey).future,
      );
      _allSongs = songs;

      // 加载版本列表
      final versionList = await ref.read(
        resourceProviderOf<List<MaimaiVersion>>(maimaiVersionListResourceKey)
            .future,
      );

      // 提取所有分类
      final genreSet = <String>{};
      for (var song in songs) {
        if (song.genre.isNotEmpty) {
          genreSet.add(song.genre);
        }
      }
      final genreList = genreSet.toList()..sort();

      state = state.copyWith(
        versions: versionList,
        genres: genreList,
        isLoading: false,
      );
    } catch (e) {
      CoreLogService.e(
        '加载数据失败: $e',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      state = state.copyWith(isLoading: false);
    }
  }

  /// 随机选曲
  void pickRandomSongs() {
    if (_allSongs.isEmpty) {
      CoreLogService.w(
        '曲目数据未加载',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      return;
    }

    // 根据筛选条件过滤曲目
    final filteredSongs = _filterSongs();

    if (filteredSongs.isEmpty) {
      CoreLogService.w(
        '没有符合条件的曲目',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      state = state.copyWith(randomSongs: []);
      return;
    }

    // 随机选取指定数量的曲目
    final count = state.pickCount.clamp(1, filteredSongs.length);
    final picked = <MaimaiSong>[];
    final availableIndices = List.generate(filteredSongs.length, (i) => i);

    for (int i = 0; i < count; i++) {
      final randomIndex = _random.nextInt(availableIndices.length);
      final songIndex = availableIndices.removeAt(randomIndex);
      picked.add(filteredSongs[songIndex]);
    }

    state = state.copyWith(randomSongs: picked);
  }

  /// 根据筛选条件过滤曲目
  List<MaimaiSong> _filterSongs() {
    return _allSongs.where((song) {
      // 版本筛选
      if (state.selectedVersionIds.isNotEmpty &&
          !state.selectedVersionIds.contains(song.version)) {
        return false;
      }

      // 分类筛选
      if (state.selectedGenres.isNotEmpty &&
          !state.selectedGenres.contains(song.genre)) {
        return false;
      }

      // 谱面类型筛选
      if (state.chartType == 'standard' && song.difficulties.standard.isEmpty) {
        return false;
      }
      if (state.chartType == 'dx' && song.difficulties.dx.isEmpty) {
        return false;
      }

      // 难度和定数筛选
      if (state.selectedDifficulties.isNotEmpty ||
          state.minLevel > 1.0 ||
          state.maxLevel < 15.0) {
        List<MaimaiSongDifficulty> difficultiesToCheck = [];
        if (state.chartType == 'all') {
          difficultiesToCheck = [
            ...song.difficulties.standard,
            ...song.difficulties.dx,
          ];
        } else if (state.chartType == 'standard') {
          difficultiesToCheck = song.difficulties.standard;
        } else if (state.chartType == 'dx') {
          difficultiesToCheck = song.difficulties.dx;
        }

        final hasMatchingDifficulty = difficultiesToCheck.any((diff) {
          if (state.selectedDifficulties.isNotEmpty &&
              !state.selectedDifficulties.contains(diff.difficulty)) {
            return false;
          }

          if (diff.levelValue < state.minLevel ||
              diff.levelValue > state.maxLevel) {
            return false;
          }

          return true;
        });

        if (!hasMatchingDifficulty) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// 设置难度筛选
  void setSelectedDifficulties(List<LevelIndex> difficulties) {
    state = state.copyWith(selectedDifficulties: difficulties);
  }

  /// 设置版本筛选
  void setSelectedVersionIds(List<int> versionIds) {
    state = state.copyWith(selectedVersionIds: versionIds);
  }

  /// 设置分类筛选
  void setSelectedGenres(List<String> genres) {
    state = state.copyWith(selectedGenres: genres);
  }

  /// 设置最小定数
  void setMinLevel(double level) {
    state = state.copyWith(minLevel: level);
  }

  /// 设置最大定数
  void setMaxLevel(double level) {
    state = state.copyWith(maxLevel: level);
  }

  /// 设置谱面类型
  void setChartType(String type) {
    state = state.copyWith(chartType: type);
  }

  /// 设置选曲数量
  void setPickCount(int count) {
    state = state.copyWith(pickCount: count);
  }

  /// 重置筛选条件
  void resetFilters() {
    state = state.copyWith(
      selectedDifficulties: [],
      selectedVersionIds: [],
      selectedGenres: [],
      minLevel: 1.0,
      maxLevel: 15.0,
      chartType: 'all',
    );
  }

  /// 清除随机结果
  void clearResults() {
    state = state.copyWith(randomSongs: []);
  }
}

/// Provider for RandomSongPickerViewModel
final randomSongPickerViewModelProvider =
    NotifierProvider<RandomSongPickerViewModel, RandomPickerState>(
      () => RandomSongPickerViewModel(),
    );
