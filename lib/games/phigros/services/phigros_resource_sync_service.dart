import 'phigros_resource_api_service.dart';
import 'phigros_isar_service.dart';

/// Phigros 资源同步服务
class PhigrosResourceSyncService {
  static final PhigrosResourceSyncService _instance =
      PhigrosResourceSyncService._internal();
  factory PhigrosResourceSyncService() => _instance;
  static PhigrosResourceSyncService get instance => _instance;

  PhigrosResourceSyncService._internal();

  final _apiService = PhigrosResourceApiService.instance;
  final _isarService = PhigrosIsarService.instance;

  /// 同步所有资源数据到数据库
  Future<void> syncAllDataToDatabase({
    required Function(int current, int total, String description) onProgress,
  }) async {
    try {
      print('🔄 开始同步Phigros资源数据...');

      onProgress(0, 100, '正在获取歌曲信息...');
      final songs = await _apiService.fetchSongs();

      onProgress(30, 100, '正在保存歌曲数据...');
      await _isarService.saveSongs(songs);

      onProgress(55, 100, '正在获取收藏品...');
      final collections = await _apiService.fetchCollections();

      onProgress(70, 100, '正在保存收藏品数据...');
      await _isarService.saveCollections(collections);

      onProgress(80, 100, '正在获取头像列表...');
      final avatars = await _apiService.fetchAvatars();

      onProgress(90, 100, '正在保存头像数据...');
      await _isarService.saveAvatars(avatars);

      onProgress(100, 100, '所有数据同步完成');

      print('✅ Phigros资源数据同步完成');
      print('   - 歌曲: ${songs.length}');
      print('   - 收藏品: ${collections.length}');
      print('   - 头像: ${avatars.length}');
    } catch (e) {
      print('❌ 同步Phigros资源数据失败: $e');
      rethrow;
    }
  }

  /// 快速同步（仅同步歌曲和收藏品）
  Future<void> quickSync({
    required Function(int current, int total, String description) onProgress,
  }) async {
    try {
      print('⚡ 开始快速同步Phigros数据...');

      onProgress(0, 100, '正在获取歌曲信息...');
      final songs = await _apiService.fetchSongs();

      onProgress(50, 100, '正在保存歌曲数据...');
      await _isarService.saveSongs(songs);

      onProgress(80, 100, '正在获取收藏品...');
      final collections = await _apiService.fetchCollections();

      onProgress(90, 100, '正在保存收藏品数据...');
      await _isarService.saveCollections(collections);

      onProgress(100, 100, '快速同步完成');

      print('✅ Phigros快速同步完成');
    } catch (e) {
      print('❌ 快速同步失败: $e');
      rethrow;
    }
  }
}
