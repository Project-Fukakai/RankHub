import 'package:isar_community/isar.dart';
import 'package:rank_hub/services/base_isar_service.dart';
import 'package:rank_hub/core/services/core_log_service.dart';

// 导入 Maimai 数据模型
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/pinned_collection.dart';
import 'package:rank_hub/games/maimai/models/net_score.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/song_type.dart';

/// Maimai 游戏数据库服务
class MaimaiIsarService extends BaseIsarService {
  static MaimaiIsarService? _instance;

  MaimaiIsarService._();

  /// 获取单例实例
  static MaimaiIsarService get instance {
    _instance ??= MaimaiIsarService._();
    return _instance!;
  }

  @override
  String get databaseName => 'maimai_db';

  @override
  List<CollectionSchema> get schemas => [
    // 玩家相关
    MaimaiPlayerSchema,
    MaimaiRatingTrendSchema,

    // 曲目相关
    MaimaiSongSchema,
    MaimaiGenreSchema,
    MaimaiVersionSchema,
    AliasSchema,

    // 成绩相关
    MaimaiScoreSchema,
    MaiMaiSimpleScoreSchema,

    // 收藏品相关
    MaimaiCollectionSchema,
    MaimaiCollectionGenreSchema,
    PinnedCollectionSchema,

    NetScoreSchema,
  ];

  Isar? _getIsarSync() {
    return Isar.getInstance(databaseName);
  }

  List<MaimaiSong>? getAllSongsSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final songs = isar.maimaiSongs.where().findAllSync();
    return songs.isEmpty ? null : songs;
  }

  List<MaimaiVersion>? getAllVersionsSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final versions = isar.maimaiVersions.where().findAllSync();
    return versions.isEmpty ? null : versions;
  }

  List<MaimaiGenre>? getAllGenresSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final genres = isar.maimaiGenres.where().findAllSync();
    return genres.isEmpty ? null : genres;
  }

  Map<int, List<String>>? getAliasMapSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final aliases = isar.alias.where().findAllSync();
    if (aliases.isEmpty) return null;
    final aliasMap = <int, List<String>>{};
    for (final alias in aliases) {
      aliasMap[alias.songId] = alias.aliases;
    }
    return aliasMap;
  }

  List<MaimaiCollection>? getAllCollectionsSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final collections = isar.maimaiCollections.where().findAllSync();
    return collections.isEmpty ? null : collections;
  }

  List<MaimaiCollectionGenre>? getAllCollectionGenresSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final genres = isar.maimaiCollectionGenres.where().findAllSync();
    return genres.isEmpty ? null : genres;
  }

  Future<Map<int, List<String>>> getAliasMap() async {
    final database = await db;
    final dbAliases = await database.alias.where().findAll();

    final aliasMap = <int, List<String>>{};
    for (final alias in dbAliases) {
      aliasMap[alias.songId] = alias.aliases;
    }
    return aliasMap;
  }

  // ==================== 玩家相关操作 ====================

  /// 保存或更新玩家信息
  Future<void> savePlayer(MaimaiPlayer player) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.maimaiPlayers.put(player);
    });
  }

  /// 根据好友码获取玩家
  Future<MaimaiPlayer?> getPlayerByFriendCode(int friendCode) async {
    final isar = await db;
    return await isar.maimaiPlayers
        .filter()
        .friendCodeEqualTo(friendCode)
        .findFirst();
  }

  /// 获取所有玩家
  Future<List<MaimaiPlayer>> getAllPlayers() async {
    final isar = await db;
    return await isar.maimaiPlayers.where().findAll();
  }

  /// 删除玩家
  Future<void> deletePlayer(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.maimaiPlayers.delete(id);
    });
  }

  /// 保存 Rating 趋势
  Future<void> saveRatingTrend(MaimaiRatingTrend trend) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.maimaiRatingTrends.put(trend);
    });
  }

  /// 获取指定日期范围的 Rating 趋势
  Future<List<MaimaiRatingTrend>> getRatingTrends({
    required String startDate,
    required String endDate,
  }) async {
    final isar = await db;
    return await isar.maimaiRatingTrends
        .filter()
        .dateBetween(startDate, endDate)
        .sortByDate()
        .findAll();
  }

  // ==================== 曲目相关操作 ====================

  /// 批量保存曲目（智能合并）
  Future<void> saveSongs(List<MaimaiSong> songs) async {
    if (songs.isEmpty) return;

    final isar = await db;
    await isar.writeTxn(() async {
      for (final song in songs) {
        // 检查是否已存在
        final existing = await isar.maimaiSongs
            .filter()
            .songIdEqualTo(song.songId)
            .findFirst();

        if (existing != null) {
          // 合并数据：保留 Isar ID，更新其他字段
          song.id = existing.id;
        }

        await isar.maimaiSongs.put(song);
      }
    });
  }

  /// 根据曲目 ID 获取曲目
  Future<MaimaiSong?> getSongById(int songId) async {
    final isar = await db;
    return await isar.maimaiSongs.filter().songIdEqualTo(songId).findFirst();
  }

  /// 搜索曲目（按标题）
  Future<List<MaimaiSong>> searchSongsByTitle(String keyword) async {
    final isar = await db;
    return await isar.maimaiSongs
        .filter()
        .titleContains(keyword, caseSensitive: false)
        .findAll();
  }

  /// 获取指定分类的曲目
  Future<List<MaimaiSong>> getSongsByGenre(String genre) async {
    final isar = await db;
    return await isar.maimaiSongs.filter().genreEqualTo(genre).findAll();
  }

  /// 获取所有曲目
  Future<List<MaimaiSong>> getAllSongs() async {
    final isar = await db;
    return await isar.maimaiSongs.where().findAll();
  }

  /// 保存分类（智能合并）
  Future<void> saveGenres(List<MaimaiGenre> genres) async {
    if (genres.isEmpty) return;

    final isar = await db;
    await isar.writeTxn(() async {
      for (final genre in genres) {
        // 检查是否已存在
        final existing = await isar.maimaiGenres
            .filter()
            .genreEqualTo(genre.genre)
            .findFirst();

        if (existing != null) {
          genre.id = existing.id;
        }

        await isar.maimaiGenres.put(genre);
      }
    });
  }

  /// 获取所有分类
  Future<List<MaimaiGenre>> getAllGenres() async {
    final isar = await db;
    return await isar.maimaiGenres.where().findAll();
  }

  /// 保存版本信息（智能合并）
  Future<void> saveVersions(List<MaimaiVersion> versions) async {
    if (versions.isEmpty) return;

    final isar = await db;
    await isar.writeTxn(() async {
      for (final version in versions) {
        // 检查是否已存在
        final existing = await isar.maimaiVersions
            .filter()
            .versionEqualTo(version.version)
            .findFirst();

        if (existing != null) {
          version.id = existing.id;
        }

        await isar.maimaiVersions.put(version);
      }
    });
  }

  /// 获取所有版本
  Future<List<MaimaiVersion>> getAllVersions() async {
    final isar = await db;
    return await isar.maimaiVersions.where().findAll();
  }

  /// 保存曲目别名（智能合并）
  Future<void> saveAliases(List<Alias> aliases) async {
    if (aliases.isEmpty) return;

    final isar = await db;
    await isar.writeTxn(() async {
      for (final alias in aliases) {
        // 检查是否已存在
        final existing = await isar.alias
            .filter()
            .songIdEqualTo(alias.songId)
            .findFirst();

        if (existing != null) {
          alias.id = existing.id;
        }

        await isar.alias.put(alias);
      }
    });
  }

  /// 根据曲目 ID 获取别名
  Future<Alias?> getAliasBySongId(int songId) async {
    final isar = await db;
    return await isar.alias.filter().songIdEqualTo(songId).findFirst();
  }

  // ==================== 成绩相关操作 ====================

  /// 批量保存成绩（智能合并）
  Future<void> saveScores(List<MaimaiScore> scores) async {
    if (scores.isEmpty) return;

    CoreLogService.i(
      '准备保存 ${scores.length} 条成绩到数据库...',
      scope: 'MAIMAI',
      platform: 'LOCAL',
    );
    final isar = await db;

    await isar.writeTxn(() async {
      int newCount = 0;
      int updateCount = 0;

      for (final score in scores) {
        // 检查是否已存在（通过曲目ID、难度和类型精确匹配）
        final existing = await isar.maimaiScores
            .filter()
            .songIdEqualTo(score.songId)
            .and()
            .levelIndexEqualTo(score.levelIndex)
            .and()
            .typeEqualTo(score.type)
            .findFirst();

        if (existing != null) {
          // 已存在，保留 Isar ID 并更新数据
          score.id = existing.id;
          updateCount++;
        } else {
          // 新数据
          newCount++;
        }

        await isar.maimaiScores.put(score);
      }

      CoreLogService.i(
        '成功保存成绩: 新增 $newCount 条, 更新 $updateCount 条',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
    });
  }

  /// 获取指定曲目的所有成绩
  Future<List<MaimaiScore>> getScoresBySongId(int songId) async {
    final isar = await db;
    return await isar.maimaiScores.filter().songIdEqualTo(songId).findAll();
  }

  /// 根据曲目ID、难度和类型获取成绩
  Future<MaimaiScore?> getScoreBySongIdAndDifficulty({
    required int songId,
    required LevelIndex levelIndex,
    required SongType type,
  }) async {
    final isar = await db;
    return await isar.maimaiScores
        .filter()
        .songIdEqualTo(songId)
        .and()
        .levelIndexEqualTo(levelIndex)
        .and()
        .typeEqualTo(type)
        .findFirst();
  }

  /// 获取所有成绩，按 DX Rating 降序
  Future<List<MaimaiScore>> getAllScoresSortedByRating() async {
    final isar = await db;
    return await isar.maimaiScores.where().sortByDxRatingDesc().findAll();
  }

  /// 获取 Best 50 成绩
  Future<List<MaimaiScore>> getBest50Scores() async {
    final isar = await db;
    return await isar.maimaiScores
        .where()
        .sortByDxRatingDesc()
        .limit(50)
        .findAll();
  }

  /// 删除成绩
  Future<void> deleteScore(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.maimaiScores.delete(id);
    });
  }

  /// 保存简化成绩
  Future<void> saveSimpleScores(List<MaiMaiSimpleScore> scores) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.maiMaiSimpleScores.putAll(scores);
    });
  }

  /// 获取所有简化成绩
  Future<List<MaiMaiSimpleScore>> getAllSimpleScores() async {
    final isar = await db;
    return await isar.maiMaiSimpleScores.where().findAll();
  }

  // ==================== 收藏品相关操作 ====================

  /// 批量保存收藏品（智能合并，避免 ID 冲突）
  Future<void> saveCollections(List<MaimaiCollection> collections) async {
    if (collections.isEmpty) return;

    CoreLogService.i(
      '准备保存 ${collections.length} 个收藏品到数据库...',
      scope: 'MAIMAI',
      platform: 'LOCAL',
    );
    final isar = await db;

    await isar.writeTxn(() async {
      int newCount = 0;
      int updateCount = 0;

      for (final collection in collections) {
        // 检查是否已存在（通过类型和收藏品ID精确匹配）
        final existing = await isar.maimaiCollections
            .filter()
            .collectionTypeEqualTo(collection.collectionType)
            .and()
            .collectionIdEqualTo(collection.collectionId)
            .findFirst();

        if (existing != null) {
          // 已存在，保留 Isar ID 并更新数据
          collection.id = existing.id;
          updateCount++;
        } else {
          // 新数据
          newCount++;
        }

        await isar.maimaiCollections.put(collection);
      }

      CoreLogService.i(
        '成功保存收藏品: 新增 $newCount 个, 更新 $updateCount 个',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
    });
  }

  /// 根据收藏品 ID 获取收藏品（可能有多个不同类型的同 ID 收藏品）
  Future<MaimaiCollection?> getCollectionById(int collectionId) async {
    final isar = await db;
    return await isar.maimaiCollections
        .filter()
        .collectionIdEqualTo(collectionId)
        .findFirst();
  }

  /// 根据收藏品类型和 ID 获取收藏品（精确查询）
  Future<MaimaiCollection?> getCollectionByTypeAndId(
    String collectionType,
    int collectionId,
  ) async {
    final isar = await db;
    return await isar.maimaiCollections
        .filter()
        .collectionTypeEqualTo(collectionType)
        .and()
        .collectionIdEqualTo(collectionId)
        .findFirst();
  }

  /// 根据类型获取收藏品列表
  Future<List<MaimaiCollection>> getCollectionsByType(
    String collectionType,
  ) async {
    final isar = await db;
    return await isar.maimaiCollections
        .filter()
        .collectionTypeEqualTo(collectionType)
        .findAll();
  }

  /// 获取指定分类的收藏品
  Future<List<MaimaiCollection>> getCollectionsByGenre(String genre) async {
    final isar = await db;
    return await isar.maimaiCollections.filter().genreEqualTo(genre).findAll();
  }

  /// 获取所有收藏品
  Future<List<MaimaiCollection>> getAllCollections() async {
    final isar = await db;
    final collections = await isar.maimaiCollections.where().findAll();
    CoreLogService.i(
      '数据库查询收藏品: 共 ${collections.length} 个',
      scope: 'MAIMAI',
      platform: 'LOCAL',
    );
    return collections;
  }

  /// 清空所有收藏品（用于数据迁移）
  Future<void> clearAllCollections() async {
    CoreLogService.i(
      '清空所有收藏品数据...',
      scope: 'MAIMAI',
      platform: 'LOCAL',
    );
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.maimaiCollections.clear();
    });
    CoreLogService.i(
      '收藏品数据已清空',
      scope: 'MAIMAI',
      platform: 'LOCAL',
    );
  }

  /// 保存收藏品分类（智能合并）
  Future<void> saveCollectionGenres(List<MaimaiCollectionGenre> genres) async {
    if (genres.isEmpty) return;

    final isar = await db;
    await isar.writeTxn(() async {
      for (final genre in genres) {
        // 检查是否已存在
        final existing = await isar.maimaiCollectionGenres
            .filter()
            .genreIdEqualTo(genre.genreId)
            .findFirst();

        if (existing != null) {
          genre.id = existing.id;
        }

        await isar.maimaiCollectionGenres.put(genre);
      }
    });
  }

  /// 获取所有收藏品分类
  Future<List<MaimaiCollectionGenre>> getAllCollectionGenres() async {
    final isar = await db;
    return await isar.maimaiCollectionGenres.where().findAll();
  }

  // ==================== 固定收藏品相关操作 ====================

  /// 保存固定的收藏品
  Future<void> pinCollection(int collectionId, String collectionType) async {
    final isar = await db;
    final pinnedCollection = PinnedCollection(
      collectionId: collectionId,
      collectionType: collectionType,
      pinnedAt: DateTime.now(),
    );

    await isar.writeTxn(() async {
      await isar.pinnedCollections.put(pinnedCollection);
    });
  }

  /// 取消固定收藏品
  Future<void> unpinCollection(int collectionId, String collectionType) async {
    final isar = await db;
    final pinned = await isar.pinnedCollections
        .filter()
        .collectionTypeEqualTo(collectionType)
        .and()
        .collectionIdEqualTo(collectionId)
        .findFirst();

    if (pinned != null) {
      await isar.writeTxn(() async {
        await isar.pinnedCollections.delete(pinned.id);
      });
    }
  }

  /// 获取所有固定的收藏品ID列表
  Future<List<PinnedCollection>> getAllPinnedCollections() async {
    final isar = await db;
    return await isar.pinnedCollections.where().sortByPinnedAt().findAll();
  }

  /// 检查收藏品是否已固定
  Future<bool> isCollectionPinned(
    int collectionId,
    String collectionType,
  ) async {
    final isar = await db;
    final count = await isar.pinnedCollections
        .filter()
        .collectionTypeEqualTo(collectionType)
        .and()
        .collectionIdEqualTo(collectionId)
        .count();
    return count > 0;
  }
}
