import 'package:isar_community/isar.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';

/// Maimai 曲目数据仓库
/// 封装曲目相关的数据访问逻辑，提供缓存优先的数据加载策略
class MaimaiSongRepository {
  final MaimaiIsarService _isarService;
  final LxnsApiService _apiService;

  MaimaiSongRepository({
    MaimaiIsarService? isarService,
    LxnsApiService? apiService,
  }) : _isarService = isarService ?? MaimaiIsarService.instance,
       _apiService = apiService ?? LxnsApiService.instance;

  /// 获取所有曲目
  /// [forceRefresh] 是否强制从 API 刷新
  Future<List<MaimaiSong>> getAllSongs({bool forceRefresh = false}) async {
    if (forceRefresh) {
      // 强制从 API 刷新
      await _apiService.syncSongsToDatabase();
      return await _isarService.getAllSongs();
    }

    // 优先从数据库加载
    final dbSongs = await _isarService.getAllSongs();
    if (dbSongs.isNotEmpty) {
      return dbSongs;
    }

    // 数据库无数据，从 API 加载
    await _apiService.syncSongsToDatabase();
    return await _isarService.getAllSongs();
  }

  /// 根据曲目 ID 获取曲目
  Future<MaimaiSong?> getSongById(int songId) async {
    return await _isarService.getSongById(songId);
  }

  /// 搜索曲目（按标题）
  Future<List<MaimaiSong>> searchSongsByTitle(String keyword) async {
    return await _isarService.searchSongsByTitle(keyword);
  }

  /// 获取所有版本信息
  Future<List<MaimaiVersion>> getVersions() async {
    final versions = await _isarService.getAllVersions();
    // 按版本号降序排列
    versions.sort((a, b) => b.version.compareTo(a.version));
    return versions;
  }

  /// 获取所有分类
  Future<List<MaimaiGenre>> getGenres() async {
    return await _isarService.getAllGenres();
  }

  /// 获取曲目别名映射 (songId -> aliases)
  Future<Map<int, List<String>>> getAliases() async {
    final database = await _isarService.db;
    final dbAliases = await database.alias.where().findAll();

    final aliasMap = <int, List<String>>{};
    for (final alias in dbAliases) {
      aliasMap[alias.songId] = alias.aliases;
    }
    return aliasMap;
  }

  /// 检查是否有缓存数据
  Future<bool> hasCachedData() async {
    final songs = await _isarService.getAllSongs();
    return songs.isNotEmpty;
  }

  /// 同步数据到数据库（带进度回调）
  Future<void> syncFromApi({
    void Function(int current, int total, String description)? onProgress,
  }) async {
    await _apiService.syncSongsToDatabase(onProgress: onProgress);
  }
}
