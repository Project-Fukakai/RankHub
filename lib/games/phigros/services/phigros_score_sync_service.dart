import 'package:rank_hub/games/phigros/services/phigros_api_service.dart';
import 'package:rank_hub/games/phigros/services/phigros_isar_service.dart';
import 'package:rank_hub/games/phigros/services/save_file_reader.dart';
import 'package:rank_hub/games/phigros/services/decrypt_save.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/game_progress.dart';

/// Phigros 玩家成绩同步服务
class PhigrosScoreSyncService {
  static final PhigrosScoreSyncService _instance =
      PhigrosScoreSyncService._internal();
  factory PhigrosScoreSyncService() => _instance;
  static PhigrosScoreSyncService get instance => _instance;

  PhigrosScoreSyncService._internal();

  final _apiService = PhigrosApiService.instance;
  final _isarService = PhigrosIsarService.instance;

  /// 同步玩家成绩数据到数据库
  ///
  /// 参数:
  /// - accountId: 账号ID
  /// - sessionToken: 用户的 session token
  /// - onProgress: 进度回调 (当前进度, 总进度, 描述)
  Future<void> syncPlayerScoresToDatabase({
    required String accountId,
    required String sessionToken,
    required Function(int current, int total, String description) onProgress,
  }) async {
    try {
      print('🔄 开始同步Phigros玩家成绩数据...');

      // 步骤1: 获取游戏存档信息 (10%)
      onProgress(0, 100, '正在获取游戏存档...');
      final gameSave = await _apiService.getGameSave(sessionToken);

      if (gameSave == null || gameSave.gameFile == null) {
        throw Exception('未找到游戏存档数据');
      }

      final saveFileUrl = gameSave.gameFile!.url;
      print('📦 存档文件URL: $saveFileUrl');

      onProgress(10, 100, '存档信息获取完成');

      // 步骤2: 下载存档文件 (20%)
      onProgress(10, 100, '正在下载存档文件...');
      final saveFileReader = SaveFileReader(saveFileUrl);
      await saveFileReader.load();

      onProgress(30, 100, '存档文件下载完成');

      // 步骤3: 获取歌曲定数和信息 (10%)
      onProgress(30, 100, '正在获取歌曲定数...');

      // 从数据库获取已同步的歌曲数据
      final songs = await _isarService.getAllSongs();
      if (songs.isEmpty) {
        throw Exception('数据库中没有歌曲数据，请先同步游戏资源');
      }

      // 构建 chartConstantList 和 songInfoList
      final chartConstantList = <String, List<double>>{};
      final songInfoList = <String, dynamic>{};

      for (final song in songs) {
        final constants = <double>[];

        // EZ, HD, IN, AT
        if (song.difficultyEZ != null && song.difficultyEZ! > 0) {
          constants.add(song.difficultyEZ!);
        }
        if (song.difficultyHD != null && song.difficultyHD! > 0) {
          constants.add(song.difficultyHD!);
        }
        if (song.difficultyIN != null && song.difficultyIN! > 0) {
          constants.add(song.difficultyIN!);
        }
        if (song.difficultyAT != null && song.difficultyAT! > 0) {
          constants.add(song.difficultyAT!);
        }

        if (constants.isNotEmpty) {
          chartConstantList[song.songId] = constants;
        }

        songInfoList[song.songId] = {
          'name': song.name,
          'artist': song.composer,
        };
      }

      print('📊 准备了 ${chartConstantList.length} 首歌曲的定数数据');

      onProgress(40, 100, '歌曲数据准备完成');

      // 步骤4: 解密并解析成绩数据 (30%)
      onProgress(40, 100, '正在解密成绩数据...');

      final decryptSave = DecryptSave(
        saveFileReader, // 传递已加载的SaveFileReader实例
        DecryptSave.DECRYPT_KEY,
        DecryptSave.DECRYPT_IV,
        chartConstantList,
        songInfoList,
      );

      // 解析成绩记录
      final recordsData = decryptSave.decryptRecords();
      print('📊 解析到 ${recordsData.length} 条成绩记录');

      onProgress(60, 100, '成绩数据解密完成');

      // 步骤5: 解析游戏进度 (10%)
      onProgress(60, 100, '正在解密游戏进度...');

      final progressData = decryptSave.decryptProgress();
      print('📈 解析到游戏进度数据');

      onProgress(70, 100, '游戏进度解密完成');

      // 步骤6: 保存到数据库 (20%)
      onProgress(70, 100, '正在保存成绩记录...');

      // 转换为数据库模型
      final records = recordsData
          .map((data) => PhigrosGameRecord.fromDecryptedData(accountId, data))
          .toList();

      // 保存成绩记录
      await _isarService.saveGameRecords(records);

      onProgress(85, 100, '成绩记录保存完成');

      // 保存游戏进度
      onProgress(85, 100, '正在保存游戏进度...');

      final progress = PhigrosGameProgress.fromDecryptedData(
        accountId,
        progressData,
      );
      await _isarService.saveGameProgress(progress);

      onProgress(95, 100, '游戏进度保存完成');

      // 步骤7: 解析并保存玩家摘要 (5%)
      onProgress(95, 100, '正在解析玩家数据摘要...');

      // 从 API 返回的 summary 解析数据
      final summaryData = gameSave.parseSummary();
      print(
        '📊 Summary 数据: RKS=${summaryData['rks']}, 课题模式=${summaryData['challengeModeRank']}',
      );

      // 保存玩家摘要（使用 API 数据而不是本地计算）
      await _isarService.savePlayerSummaryFromApi(
        accountId,
        summaryData['rks'],
        summaryData['challengeModeRank'],
        summaryData['levelRecords'],
        summaryData['avatarName'] ?? '',
      );

      onProgress(100, 100, '所有数据同步完成');

      print('✅ Phigros玩家成绩数据同步完成');
      print('   - 成绩记录: ${records.length} 条');
      print('   - 课题模式: ${progress.challengeRankDescription}');
    } catch (e, stackTrace) {
      print('❌ 同步Phigros玩家成绩数据失败: $e');
      print(stackTrace);
      rethrow;
    }
  }

  /// 获取玩家数据摘要（不触发同步）
  Future<Map<String, dynamic>?> getPlayerSummary(String accountId) async {
    try {
      final summary = await _isarService.getPlayerSummary(accountId);
      if (summary == null) return null;

      return {
        'totalRks': summary.totalRks,
        'b19AverageRks': summary.b19AverageRks,
        'phiCount': summary.phiCount,
        'fcCount': summary.fcCount,
        'totalSongsPlayed': summary.totalSongsPlayed,
        'challengeModeRank': summary.challengeModeRank,
        'lastUpdated': summary.lastUpdated.toIso8601String(),
      };
    } catch (e) {
      print('❌ 获取玩家数据摘要失败: $e');
      return null;
    }
  }

  /// 获取玩家成绩列表
  Future<List<Map<String, dynamic>>> getPlayerRecords(
    String accountId, {
    String? level,
    int? limit,
  }) async {
    try {
      List<PhigrosGameRecord> records;

      if (level != null) {
        records = await _isarService.getRecordsByLevel(accountId, level);
      } else {
        records = await _isarService.getGameRecords(accountId);
      }

      if (limit != null && records.length > limit) {
        records = records.take(limit).toList();
      }

      return records.map((r) => r.toMap()).toList();
    } catch (e) {
      print('❌ 获取玩家成绩列表失败: $e');
      return [];
    }
  }

  /// 清除玩家存档数据
  Future<void> clearPlayerData(String accountId) async {
    try {
      await _isarService.clearAccountSaveData(accountId);
      print('🗑️ 已清除账号 $accountId 的玩家数据');
    } catch (e) {
      print('❌ 清除玩家数据失败: $e');
      rethrow;
    }
  }
}
