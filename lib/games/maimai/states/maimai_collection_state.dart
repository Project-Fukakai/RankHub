import 'package:flutter/foundation.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';

/// 收藏品筛选条件
@immutable
class CollectionFilter {
  final String searchKeyword;
  final String selectedType; // 'plate', 'icon', 'frame', 'trophy'

  const CollectionFilter({
    this.searchKeyword = '',
    this.selectedType = 'plate',
  });

  CollectionFilter copyWith({String? searchKeyword, String? selectedType}) {
    return CollectionFilter(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  /// 应用筛选逻辑
  List<MaimaiCollection> apply(List<MaimaiCollection> collections) {
    return collections.where((c) {
      // 按类型筛选
      if (c.collectionType != selectedType) {
        return false;
      }

      // 按搜索关键词筛选
      if (searchKeyword.isNotEmpty) {
        final keyword = searchKeyword.toLowerCase();
        return c.name.toLowerCase().contains(keyword) ||
            (c.description?.toLowerCase().contains(keyword) ?? false);
      }

      return true;
    }).toList();
  }
}

/// Maimai 收藏品状态
@immutable
class MaimaiCollectionState {
  final List<MaimaiCollection> allCollections;
  final List<MaimaiCollection> filteredCollections;
  final CollectionFilter currentFilter;
  final DataLoadStatus loadStatus;
  final String? errorMessage;
  final bool isFromCache;

  // 元数据
  final List<MaimaiCollectionGenre> genres;

  const MaimaiCollectionState({
    this.allCollections = const [],
    this.filteredCollections = const [],
    this.currentFilter = const CollectionFilter(),
    this.loadStatus = DataLoadStatus.idle,
    this.errorMessage,
    this.isFromCache = false,
    this.genres = const [],
  });

  MaimaiCollectionState copyWith({
    List<MaimaiCollection>? allCollections,
    List<MaimaiCollection>? filteredCollections,
    CollectionFilter? currentFilter,
    DataLoadStatus? loadStatus,
    String? errorMessage,
    bool? isFromCache,
    List<MaimaiCollectionGenre>? genres,
  }) {
    return MaimaiCollectionState(
      allCollections: allCollections ?? this.allCollections,
      filteredCollections: filteredCollections ?? this.filteredCollections,
      currentFilter: currentFilter ?? this.currentFilter,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage,
      isFromCache: isFromCache ?? this.isFromCache,
      genres: genres ?? this.genres,
    );
  }

  /// 获取收藏品类型选项
  List<Map<String, String>> getTypeOptions() {
    return [
      {'value': 'plate', 'label': '姓名框'},
      {'value': 'icon', 'label': '头像'},
      {'value': 'frame', 'label': '背景'},
      {'value': 'trophy', 'label': '称号'},
    ];
  }
}
