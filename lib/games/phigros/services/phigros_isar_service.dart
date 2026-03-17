import 'package:isar_community/isar.dart';
import 'package:rank_hub/services/base_isar_service.dart';
import 'package:rank_hub/models/phigros/song.dart';
import 'package:rank_hub/models/phigros/collection.dart';
import 'package:rank_hub/models/phigros/avatar.dart';
import 'package:rank_hub/models/phigros/game_progress.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/player_summary.dart';

/// Phigros Isar 数据库服务
class PhigrosIsarService extends BaseIsarService {
  static final PhigrosIsarService _instance = PhigrosIsarService._internal();
  factory PhigrosIsarService() => _instance;
  static PhigrosIsarService get instance => _instance;

  PhigrosIsarService._internal();

  @override
  String get databaseName => 'phigros';

  @override
  List<CollectionSchema> get schemas => [
    PhigrosSongSchema,
    PhigrosCollectionSchema,
    PhigrosAvatarSchema,
    PhigrosGameProgressSchema,
    PhigrosGameRecordSchema,
    PhigrosPlayerSummarySchema,
  ];

  Isar? _getIsarSync() {
    return Isar.getInstance(databaseName);
  }

  List<PhigrosSong>? getAllSongsSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final songs = isar.phigrosSongs.where().findAllSync();
    return songs.isEmpty ? null : songs;
  }

  List<PhigrosCollection>? getAllCollectionsSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final collections = isar.phigrosCollections.where().findAllSync();
    return collections.isEmpty ? null : collections;
  }

  List<PhigrosAvatar>? getAllAvatarsSyncOrNull() {
    final isar = _getIsarSync();
    if (isar == null) return null;
    final avatars = isar.phigrosAvatars.where().findAllSync();
    return avatars.isEmpty ? null : avatars;
  }

  // ========== 歌曲操作 ==========

  /// 保存歌曲列表
  Future<void> saveSongs(List<PhigrosSong> songs) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // 清除旧数据避免唯一索引冲突
      await isar.phigrosSongs.clear();
      await isar.phigrosSongs.putAll(songs);
    });
    print('💾 保存了 ${songs.length} 首歌曲到数据库');
  }

  /// 获取所有歌曲
  Future<List<PhigrosSong>> getAllSongs() async {
    final isar = await db;
    return await isar.phigrosSongs.where().findAll();
  }

  /// 根据ID获取歌曲
  Future<PhigrosSong?> getSongById(String songId) async {
    final isar = await db;
    return await isar.phigrosSongs.filter().songIdEqualTo(songId).findFirst();
  }

  /// 根据名称搜索歌曲
  Future<List<PhigrosSong>> searchSongsByName(String keyword) async {
    final isar = await db;
    return await isar.phigrosSongs
        .filter()
        .nameContains(keyword, caseSensitive: false)
        .or()
        .composerContains(keyword, caseSensitive: false)
        .findAll();
  }

  /// 获取歌曲总数
  Future<int> getSongCount() async {
    final isar = await db;
    return await isar.phigrosSongs.count();
  }

  // ========== 收藏品操作 ==========

  /// 保存收藏品列表
  Future<void> saveCollections(List<PhigrosCollection> collections) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // 清除旧数据避免唯一索引冲突
      await isar.phigrosCollections.clear();
      await isar.phigrosCollections.putAll(collections);
    });
    print('💾 保存了 ${collections.length} 个收藏品到数据库');
  }

  /// 获取所有收藏品
  Future<List<PhigrosCollection>> getAllCollections() async {
    final isar = await db;
    return await isar.phigrosCollections.where().findAll();
  }

  /// 根据ID获取收藏品
  Future<PhigrosCollection?> getCollectionById(String collectionId) async {
    final isar = await db;
    return await isar.phigrosCollections
        .filter()
        .collectionIdEqualTo(collectionId)
        .findFirst();
  }

  /// 获取收藏品总数
  Future<int> getCollectionCount() async {
    final isar = await db;
    return await isar.phigrosCollections.count();
  }

  // ========== 头像操作 ==========

  /// 保存头像列表
  Future<void> saveAvatars(List<PhigrosAvatar> avatars) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // 清除旧数据避免唯一索引冲突
      await isar.phigrosAvatars.clear();
      await isar.phigrosAvatars.putAll(avatars);
    });
    print('💾 保存了 ${avatars.length} 个头像到数据库');
  }

  /// 获取所有头像
  Future<List<PhigrosAvatar>> getAllAvatars() async {
    final isar = await db;
    return await isar.phigrosAvatars.where().findAll();
  }

  /// 根据名称获取头像
  Future<PhigrosAvatar?> getAvatarByName(String avatarName) async {
    final isar = await db;
    return await isar.phigrosAvatars
        .filter()
        .avatarNameEqualTo(avatarName)
        .findFirst();
  }

  /// 获取头像总数
  Future<int> getAvatarCount() async {
    final isar = await db;
    return await isar.phigrosAvatars.count();
  }

  // ========== 游戏进度操作 ==========

  /// 保存游戏进度
  Future<void> saveGameProgress(PhigrosGameProgress progress) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.phigrosGameProgress.put(progress);
    });
    print('💾 保存了游戏进度到数据库');
  }

  /// 获取指定账号的游戏进度
  Future<PhigrosGameProgress?> getGameProgress(String accountId) async {
    final isar = await db;
    return await isar.phigrosGameProgress
        .filter()
        .accountIdEqualTo(accountId)
        .findFirst();
  }

  // ========== 游戏成绩操作 ==========

  /// 保存游戏成绩列表（会先清除该账号的旧成绩）
  Future<void> saveGameRecords(List<PhigrosGameRecord> records) async {
    if (records.isEmpty) {
      print('⚠️ 没有成绩记录需要保存');
      return;
    }

    final isar = await db;
    final accountId = records.first.accountId;

    await isar.writeTxn(() async {
      // 先删除该账号的所有旧成绩
      final oldRecords = await isar.phigrosGameRecords
          .filter()
          .accountIdEqualTo(accountId)
          .findAll();

      if (oldRecords.isNotEmpty) {
        await isar.phigrosGameRecords.deleteAll(
          oldRecords.map((r) => r.id).toList(),
        );
        print('🗑️ 清除了 ${oldRecords.length} 条旧成绩记录');
      }

      // 保存新成绩
      await isar.phigrosGameRecords.putAll(records);
    });
    print('💾 保存了 ${records.length} 条成绩记录到数据库');
  }

  /// 获取指定账号的所有成绩
  Future<List<PhigrosGameRecord>> getGameRecords(String accountId) async {
    final isar = await db;
    return await isar.phigrosGameRecords
        .filter()
        .accountIdEqualTo(accountId)
        .sortByRksDesc()
        .findAll();
  }

  /// 获取指定账号的B19成绩
  Future<List<PhigrosGameRecord>> getB19Records(String accountId) async {
    final isar = await db;
    return await isar.phigrosGameRecords
        .filter()
        .accountIdEqualTo(accountId)
        .sortByRksDesc()
        .limit(19)
        .findAll();
  }

  /// 获取指定歌曲的成绩
  Future<List<PhigrosGameRecord>> getSongRecords(
    String accountId,
    String songId,
  ) async {
    final isar = await db;
    return await isar.phigrosGameRecords
        .filter()
        .accountIdEqualTo(accountId)
        .and()
        .songIdEqualTo(songId)
        .findAll();
  }

  /// 获取指定难度的成绩列表
  Future<List<PhigrosGameRecord>> getRecordsByLevel(
    String accountId,
    String level,
  ) async {
    final isar = await db;
    return await isar.phigrosGameRecords
        .filter()
        .accountIdEqualTo(accountId)
        .and()
        .levelEqualTo(level)
        .sortByRksDesc()
        .findAll();
  }

  /// 获取成绩总数
  Future<int> getRecordCount(String accountId) async {
    final isar = await db;
    return await isar.phigrosGameRecords
        .filter()
        .accountIdEqualTo(accountId)
        .count();
  }

  // ========== 玩家摘要操作 ==========

  /// 保存玩家数据摘要
  Future<void> savePlayerSummary(PhigrosPlayerSummary summary) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // 先查找是否已存在该 accountId 的记录
      final existing = await isar.phigrosPlayerSummarys
          .filter()
          .accountIdEqualTo(summary.accountId)
          .findFirst();

      // 如果存在，使用已有的 ID 进行更新
      if (existing != null) {
        summary.id = existing.id;
      }

      await isar.phigrosPlayerSummarys.put(summary);
    });
    print('💾 保存了玩家数据摘要到数据库');
  }

  /// 获取玩家数据摘要
  Future<PhigrosPlayerSummary?> getPlayerSummary(String accountId) async {
    final isar = await db;
    return await isar.phigrosPlayerSummarys
        .filter()
        .accountIdEqualTo(accountId)
        .findFirst();
  }

  /// 计算并保存玩家数据摘要
  Future<PhigrosPlayerSummary> calculateAndSavePlayerSummary(
    String accountId,
  ) async {
    // 获取成绩和进度
    final records = await getGameRecords(accountId);
    final progress = await getGameProgress(accountId);

    // 计算摘要
    final summary = PhigrosPlayerSummary.calculate(
      accountId,
      records,
      progress?.challengeModeRank ?? 0,
    );

    // 保存摘要
    await savePlayerSummary(summary);

    return summary;
  }

  /// 从 API 数据保存玩家摘要
  /// 使用 API 返回的 RKS、课题模式排名和 levelRecords
  Future<PhigrosPlayerSummary> savePlayerSummaryFromApi(
    String accountId,
    double rks,
    int challengeModeRank,
    List<int> levelRecords,
    String avatarName,
  ) async {
    // 获取成绩用于计算其他统计数据
    final records = await getGameRecords(accountId);

    // 从 levelRecords 解析各难度的 Clear/FC/AP 数量
    // [0-2]: EZ Clear/FC/AP, [3-5]: HD Clear/FC/AP,
    // [6-8]: IN Clear/FC/AP, [9-11]: AT Clear/FC/AP
    final ezCount = levelRecords[0];
    final hdCount = levelRecords[3];
    final inCount = levelRecords[6];
    final atCount = levelRecords[9];
    final fcCount =
        levelRecords[1] + levelRecords[4] + levelRecords[7] + levelRecords[10];

    // 创建摘要（使用 API 数据）
    final summary = PhigrosPlayerSummary.calculateWithApiData(
      accountId,
      records,
      rks,
      challengeModeRank,
      ezCount: ezCount,
      hdCount: hdCount,
      inCount: inCount,
      atCount: atCount,
      fcCount: fcCount,
      avatarName: avatarName,
    );

    // 保存摘要
    await savePlayerSummary(summary);

    print('✅ 保存玩家摘要: RKS=$rks, 课题模式=$challengeModeRank');
    print('   EZ=$ezCount, HD=$hdCount, IN=$inCount, AT=$atCount, FC=$fcCount');

    return summary;
  }

  // ========== 清理操作 ==========

  /// 清空所有资源数据
  Future<void> clearAllResourceData() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.phigrosSongs.clear();
      await isar.phigrosCollections.clear();
      await isar.phigrosAvatars.clear();
    });
    print('🗑️ 已清空所有Phigros资源数据');
  }

  /// 清空指定账号的存档数据
  Future<void> clearAccountSaveData(String accountId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // 删除游戏进度
      final progress = await isar.phigrosGameProgress
          .filter()
          .accountIdEqualTo(accountId)
          .findAll();
      await isar.phigrosGameProgress.deleteAll(
        progress.map((e) => e.id).toList(),
      );

      // 删除游戏成绩
      final records = await isar.phigrosGameRecords
          .filter()
          .accountIdEqualTo(accountId)
          .findAll();
      await isar.phigrosGameRecords.deleteAll(
        records.map((e) => e.id).toList(),
      );

      // 删除玩家摘要
      final summary = await isar.phigrosPlayerSummarys
          .filter()
          .accountIdEqualTo(accountId)
          .findAll();
      await isar.phigrosPlayerSummarys.deleteAll(
        summary.map((e) => e.id).toList(),
      );
    });
    print('🗑️ 已清空账号 $accountId 的Phigros存档数据');
  }

  /// 清空所有数据（包括资源和存档）
  Future<void> clearAllData() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.phigrosSongs.clear();
      await isar.phigrosCollections.clear();
      await isar.phigrosAvatars.clear();
      await isar.phigrosGameProgress.clear();
      await isar.phigrosGameRecords.clear();
      await isar.phigrosPlayerSummarys.clear();
    });
    print('🗑️ 已清空所有Phigros数据');
  }
}
