import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/states/maimai_collection_state.dart';

/// Maimai 收藏品 ViewModel
/// 管理收藏品数据的加载和筛选
class MaimaiCollectionViewModel extends Notifier<MaimaiCollectionState> {
  @override
  MaimaiCollectionState build() {
    // 自动加载数据
    Future.microtask(() => loadCollections());

    return const MaimaiCollectionState();
  }

  /// 加载收藏品数据
  /// [forceRefresh] 是否强制从 API 刷新
  Future<void> loadCollections({bool forceRefresh = false}) async {
    CoreLogService.i(
      '开始加载收藏品数据 (forceRefresh: $forceRefresh)',
      scope: 'MAIMAI',
      platform: 'LOCAL',
    );

    state = state.copyWith(
      loadStatus: forceRefresh
          ? DataLoadStatus.loadingFromApi
          : DataLoadStatus.loadingFromDb,
      errorMessage: null,
    );

    try {
      if (forceRefresh) {
        await ref.read(
          refreshResourceProviderOf<List<MaimaiCollection>>(
            maimaiCollectionListResourceKey,
          ).future,
        );
      }

      // 并行加载收藏品和分类
      final results = await Future.wait([
        ref.read(
          resourceProviderOf<List<MaimaiCollection>>(
            maimaiCollectionListResourceKey,
          ).future,
        ),
        ref.read(
          resourceProviderOf<List<MaimaiCollectionGenre>>(
            maimaiCollectionGenreListResourceKey,
          ).future,
        ),
      ]);

      final collections = results[0] as List<MaimaiCollection>;
      final genres = results[1] as List<MaimaiCollectionGenre>;

      CoreLogService.i(
        '加载到 ${collections.length} 个收藏品',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );

      state = state.copyWith(
        allCollections: collections,
        genres: genres,
        loadStatus: DataLoadStatus.success,
        isFromCache: !forceRefresh,
      );

      // 应用当前筛选条件
      _applyFilter();

      CoreLogService.i(
        '收藏品加载完成，筛选后数量: ${state.filteredCollections.length}',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
    } catch (e) {
      CoreLogService.e(
        '加载收藏品失败: $e',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      state = state.copyWith(
        loadStatus: DataLoadStatus.error,
        errorMessage: '加载收藏品失败: $e',
      );
    }
  }

  /// 设置收藏品类型筛选
  void setCollectionType(String type) {
    state = state.copyWith(
      currentFilter: state.currentFilter.copyWith(selectedType: type),
    );
    _applyFilter();
  }

  /// 设置搜索关键词
  void setSearchKeyword(String keyword) {
    state = state.copyWith(
      currentFilter: state.currentFilter.copyWith(searchKeyword: keyword),
    );
    _applyFilter();
  }

  /// 清除筛选条件
  void clearFilters() {
    state = state.copyWith(
      currentFilter: const CollectionFilter(),
    );
    _applyFilter();
  }

  /// 应用筛选条件
  void _applyFilter() {
    final filtered = state.currentFilter.apply(state.allCollections);
    state = state.copyWith(filteredCollections: filtered);
  }

  /// 获取收藏品类型的显示标签
  String getTypeLabel(String type) {
    switch (type) {
      case 'plate':
        return '姓名框';
      case 'icon':
        return '头像';
      case 'frame':
        return '背景';
      case 'trophy':
        return '称号';
      default:
        return type;
    }
  }
}

/// Provider for MaimaiCollectionViewModel
final maimaiCollectionViewModelProvider =
    NotifierProvider<MaimaiCollectionViewModel, MaimaiCollectionState>(
  () => MaimaiCollectionViewModel(),
);
