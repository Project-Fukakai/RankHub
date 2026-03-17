import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/core_context.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_song_catalog.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/states/maimai_song_state.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';

/// Maimai 曲目 ViewModel
/// 管理曲目数据的加载、筛选和搜索
class MaimaiSongViewModel extends Notifier<MaimaiSongState> {
  @override
  MaimaiSongState build() {
    final appContext = ref.watch(appContextProvider);
    if (appContext != null) {
      // 自动加载数据（AppContext 就绪后）
      Future.microtask(() => loadSongs());
    }

    return const MaimaiSongState();
  }

  /// 加载曲目数据
  /// [forceRefresh] 是否强制从 API 刷新
  Future<void> loadSongs({bool forceRefresh = false}) async {
    state = state.copyWith(
      loadStatus: forceRefresh
          ? DataLoadStatus.loadingFromApi
          : DataLoadStatus.loadingFromDb,
      errorMessage: null,
    );

    try {
      if (forceRefresh) {
        await ref.read(
          refreshResourceProviderOf<MaimaiSongCatalog>(
            maimaiSongCatalogResourceKey,
          ).future,
        );
      }

      // 并行加载所有数据
      final results = await Future.wait([
        ref.read(
          resourceProviderOf<List<MaimaiSong>>(maimaiSongListResourceKey).future,
        ),
        ref.read(
          resourceProviderOf<List<MaimaiVersion>>(maimaiVersionListResourceKey)
              .future,
        ),
        ref.read(
          resourceProviderOf<List<MaimaiGenre>>(maimaiGenreListResourceKey)
              .future,
        ),
        ref.read(
          resourceProviderOf<Map<int, List<String>>>(maimaiAliasMapResourceKey)
              .future,
        ),
      ]);

      final songs = results[0] as List<MaimaiSong>;
      final versions = results[1] as List<MaimaiVersion>;
      final genres = results[2] as List<MaimaiGenre>;
      final aliases = results[3] as Map<int, List<String>>;

      if ((songs.isEmpty || versions.isEmpty) && !forceRefresh) {
        await loadSongs(forceRefresh: true);
        return;
      }

      state = state.copyWith(
        allSongs: songs,
        versions: versions,
        genres: genres,
        aliases: aliases,
        loadStatus: DataLoadStatus.success,
        isFromCache: !forceRefresh,
      );

      // 应用当前筛选条件
      _applyFilter();
    } catch (e) {
      state = state.copyWith(
        loadStatus: DataLoadStatus.error,
        errorMessage: '加载曲目失败: $e',
      );
    }
  }

  /// 设置搜索关键词
  void setSearchKeyword(String keyword) {
    state = state.copyWith(
      currentFilter: state.currentFilter.copyWith(searchKeyword: keyword),
    );
    _applyFilter();
  }

  /// 设置分类筛选
  void setGenreFilter(String? genre) {
    state = state.copyWith(
      currentFilter: state.currentFilter.copyWith(selectedGenre: genre),
    );
    _applyFilter();
  }

  /// 设置版本筛选
  void setVersionFilter(int? versionId) {
    state = state.copyWith(
      currentFilter: state.currentFilter.copyWith(selectedVersionId: versionId),
    );
    _applyFilter();
  }

  /// 设置谱面类型筛选
  void setTypeFilter(String? type) {
    state = state.copyWith(
      currentFilter: state.currentFilter.copyWith(selectedType: type),
    );
    _applyFilter();
  }

  /// 清除所有筛选条件
  void clearFilters() {
    state = state.copyWith(currentFilter: const SongFilter());
    _applyFilter();
  }

  /// 应用筛选条件
  void _applyFilter() {
    final filtered = state.currentFilter.apply(
      state.allSongs,
      state.aliases,
      state.versions,
    );
    state = state.copyWith(filteredSongs: filtered);
  }

  /// 根据曲目版本号获取所属版本信息
  String getVersionLabel(int versionNumber) {
    if (state.versions.isEmpty) return '';

    final exact = state.versions
        .where((v) => v.versionId == versionNumber)
        .firstOrNull;
    if (exact != null) {
      return exact.title;
    }

    // Fallback: treat input as song version number
    if (versionNumber >= state.versions.first.version) {
      return state.versions.first.title;
    }
    if (versionNumber < state.versions.last.version) {
      return state.versions.last.title;
    }
    for (int i = 0; i < state.versions.length - 1; i++) {
      final currentVersion = state.versions[i];
      final nextVersion = state.versions[i + 1];
      if (versionNumber >= nextVersion.version &&
          versionNumber < currentVersion.version) {
        return nextVersion.title;
      }
    }
    return '';
  }

  /// 获取谱面类型的显示标签
  String getTypeLabel(String type) {
    switch (type) {
      case 'standard':
        return 'Standard';
      case 'dx':
        return 'DX';
      case 'utage':
        return '宴会场';
      default:
        return '';
    }
  }
}

/// Provider for MaimaiSongViewModel
final maimaiSongViewModelProvider =
    NotifierProvider<MaimaiSongViewModel, MaimaiSongState>(
  () => MaimaiSongViewModel(),
);
