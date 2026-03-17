import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/pinned_collection.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';

/// Maimai 收藏品数据仓库
/// 封装收藏品相关的数据访问逻辑
class MaimaiCollectionRepository {
  final MaimaiIsarService _isarService;
  final LxnsApiService _apiService;

  MaimaiCollectionRepository({
    MaimaiIsarService? isarService,
    LxnsApiService? apiService,
  })  : _isarService = isarService ?? MaimaiIsarService.instance,
        _apiService = apiService ?? LxnsApiService.instance;

  /// 获取所有收藏品
  /// [forceRefresh] 是否强制从 API 刷新
  Future<List<MaimaiCollection>> getAllCollections({
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      await _apiService.syncCollectionsToDatabase();
      return await _isarService.getAllCollections();
    }

    final dbCollections = await _isarService.getAllCollections();
    if (dbCollections.isNotEmpty) {
      return dbCollections;
    }

    await _apiService.syncCollectionsToDatabase();
    return await _isarService.getAllCollections();
  }

  /// 根据类型获取收藏品
  Future<List<MaimaiCollection>> getCollectionsByType(
    String collectionType,
  ) async {
    return await _isarService.getCollectionsByType(collectionType);
  }

  /// 根据类型和 ID 获取收藏品
  Future<MaimaiCollection?> getCollectionByTypeAndId(
    String collectionType,
    int collectionId,
  ) async {
    return await _isarService.getCollectionByTypeAndId(
      collectionType,
      collectionId,
    );
  }

  /// 获取所有收藏品分类
  Future<List<MaimaiCollectionGenre>> getCollectionGenres() async {
    return await _isarService.getAllCollectionGenres();
  }

  /// 固定收藏品
  Future<void> pinCollection(int collectionId, String collectionType) async {
    await _isarService.pinCollection(collectionId, collectionType);
  }

  /// 取消固定收藏品
  Future<void> unpinCollection(int collectionId, String collectionType) async {
    await _isarService.unpinCollection(collectionId, collectionType);
  }

  /// 获取所有固定的收藏品
  Future<List<PinnedCollection>> getPinnedCollections() async {
    return await _isarService.getAllPinnedCollections();
  }

  /// 检查收藏品是否已固定
  Future<bool> isCollectionPinned(
    int collectionId,
    String collectionType,
  ) async {
    return await _isarService.isCollectionPinned(collectionId, collectionType);
  }

  /// 检查是否有缓存数据
  Future<bool> hasCachedData() async {
    final collections = await _isarService.getAllCollections();
    return collections.isNotEmpty;
  }

  /// 同步数据到数据库（带进度回调）
  Future<void> syncFromApi({
    void Function(int current, int total, String description)? onProgress,
  }) async {
    await _apiService.syncCollectionsToDatabase(onProgress: onProgress);
  }
}
