import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rank_hub/models/phigros/avatar.dart';
import 'package:rank_hub/models/phigros/chart.dart';
import 'package:rank_hub/models/phigros/collection.dart';
import 'package:rank_hub/models/phigros/song.dart';

/// Phigros 资源 API 服务
class PhigrosResourceApiService {
  static final PhigrosResourceApiService _instance =
      PhigrosResourceApiService._internal();

  factory PhigrosResourceApiService() => _instance;

  static PhigrosResourceApiService get instance => _instance;

  PhigrosResourceApiService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://somnia.xtower.site',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// 获取乐曲定数表
  /// 格式: 曲名.曲师 EZ定数 HD定数 IN定数 AT定数(如有)
  Future<Map<String, Map<String, double>>> fetchDifficulties() async {
    try {
      print('📥 开始获取定数表...');
      final response = await _dio.get<String>('/info/difficulty.tsv');
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final lines = responseData.split('\n');
        final difficulties = <String, Map<String, double>>{};
        int invalidLineCount = 0;

        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          final parts = line.split('\t');
          if (parts.length < 4) {
            invalidLineCount++;
            print('⚠️ 跳过格式不正确的定数行 (字段数 < 4): $line');
            continue;
          }

          final key = parts[0].trim(); // 曲名.曲师
          final ez = double.tryParse(parts[1].trim());
          final hd = double.tryParse(parts[2].trim());
          final inDiff = double.tryParse(parts[3].trim());
          final at = parts.length > 4 ? double.tryParse(parts[4].trim()) : null;

          if (ez == null || hd == null || inDiff == null) {
            print(
              '⚠️ 定数解析失败: "$key" - EZ:${parts[1]}, HD:${parts[2]}, IN:${parts[3]}',
            );
          }

          difficulties[key] = {
            'EZ': ez ?? 0.0,
            'HD': hd ?? 0.0,
            'IN': inDiff ?? 0.0,
            if (at != null && at > 0) 'AT': at,
          };
        }

        print('✅ 获取定数表完成: ${difficulties.length} 首曲目');
        if (invalidLineCount > 0) {
          print('⚠️ 跳过了 $invalidLineCount 行无效数据');
        }
        return difficulties;
      }

      throw Exception('获取定数表失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取定数表失败: $e');
      rethrow;
    }
  }

  /// 获取乐曲信息
  /// 格式: 曲ID 曲名 曲师 曲绘画师 EZ谱师 HD谱师 IN谱师 AT谱师(如有)
  Future<List<PhigrosSong>> fetchSongs() async {
    try {
      print('📥 开始获取乐曲信息...');

      // 同时获取乐曲信息和定数表
      final infoResponse = await _dio.get<String>('/info/info.tsv');
      final difficulties = await fetchDifficulties();
      final infoResponseData = infoResponse.data;

      if (infoResponse.statusCode == 200 && infoResponseData != null) {
        final lines = infoResponseData.split('\n');
        final songs = <PhigrosSong>[];
        int missingDifficultyCount = 0;

        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          final parts = line.split('\t');
          if (parts.length < 7) {
            print('⚠️ 跳过格式不正确的行 (字段数 < 7): $line');
            continue;
          }

          final songId = parts[0].trim();
          final name = parts[1].trim();
          final composer = parts[2].trim();
          final illustrator = parts[3].trim();
          final chartEZ = parts[4].trim();
          final chartHD = parts[5].trim();
          final chartIN = parts[6].trim();
          final chartAT = parts.length > 7 ? parts[7].trim() : null;

          // 直接使用 songId 查找定数（songId 格式为 "曲名.曲师"）
          final diff = difficulties[songId];

          // 调试：检查是否找到对应的定数
          if (diff == null) {
            missingDifficultyCount++;
            print(
              '⚠️ 未找到定数 [#$missingDifficultyCount]: "$name" by "$composer"',
            );
            print('   songId: "$songId"');
            print('   可用的定数表键示例: ${difficulties.keys.take(3).join(", ")}');
          } else {
            final hasAllDifficulties =
                diff['EZ'] != null && diff['HD'] != null && diff['IN'] != null;
            if (!hasAllDifficulties) {
              print(
                '⚠️ 定数不完整: "$name" - EZ:${diff['EZ']}, HD:${diff['HD']}, IN:${diff['IN']}, AT:${diff['AT']}',
              );
            }
          }

          songs.add(
            PhigrosSong.fromTsvData(
              songId: songId,
              name: name,
              composer: composer,
              illustrator: illustrator.isNotEmpty ? illustrator : null,
              chartDesignerEZ: chartEZ.isNotEmpty ? chartEZ : null,
              chartDesignerHD: chartHD.isNotEmpty ? chartHD : null,
              chartDesignerIN: chartIN.isNotEmpty ? chartIN : null,
              chartDesignerAT: chartAT?.isNotEmpty == true ? chartAT : null,
              difficultyEZ: diff?['EZ'],
              difficultyHD: diff?['HD'],
              difficultyIN: diff?['IN'],
              difficultyAT: diff?['AT'],
            ),
          );
        }

        print('✅ 获取乐曲信息完成: ${songs.length} 首曲目');
        if (missingDifficultyCount > 0) {
          print('⚠️ 有 $missingDifficultyCount 首歌曲未找到对应的定数');
        }
        return songs;
      }

      throw Exception('获取乐曲信息失败: ${infoResponse.statusCode}');
    } catch (e) {
      print('❌ 获取乐曲信息失败: $e');
      rethrow;
    }
  }

  /// 获取收藏品列表
  /// 格式: 收藏品ID 名称 数量
  Future<List<PhigrosCollection>> fetchCollections() async {
    try {
      print('📥 开始获取收藏品...');
      final response = await _dio.get<String>('/info/collection.tsv');
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final lines = responseData.split('\n');
        final collections = <PhigrosCollection>[];

        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          try {
            collections.add(PhigrosCollection.fromTsvLine(line));
          } catch (e) {
            print('⚠️ 跳过无效收藏品数据: $line');
          }
        }

        print('✅ 获取收藏品完成: ${collections.length} 个收藏品');
        return collections;
      }

      throw Exception('获取收藏品失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取收藏品失败: $e');
      rethrow;
    }
  }

  /// 获取头像名称列表
  Future<List<PhigrosAvatar>> fetchAvatars() async {
    try {
      print('📥 开始获取头像列表...');
      final response = await _dio.get<String>('/info/avatar.txt');
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final lines = responseData.split('\n');
        final avatars = <PhigrosAvatar>[];

        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          avatars.add(PhigrosAvatar.fromName(line));
        }

        print('✅ 获取头像列表完成: ${avatars.length} 个头像');
        return avatars;
      }

      throw Exception('获取头像列表失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取头像列表失败: $e');
      rethrow;
    }
  }

  /// 获取谱面数据
  /// [songId] 曲目ID（格式：曲名.曲师）
  /// [difficulty] 难度（EZ/HD/IN/AT）
  Future<PhigrosChart> fetchChart(String songId, String difficulty) async {
    try {
      // URL 格式: /chart/{songId}.0/{difficulty}.json
      final url = '/chart/$songId.0/$difficulty.json';

      print('📥 开始获取谱面: $songId - $difficulty');
      print('   URL: $url');

      final response = await _dio.get<String>(url);
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final chart = PhigrosChart.fromJson(
          jsonDecode(responseData) as Map<String, dynamic>,
        );
        print('✅ 获取谱面完成: ${chart.totalNotes} 个音符');
        return chart;
      }

      throw Exception('获取谱面失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取谱面失败: $songId - $difficulty, 错误: $e');
      rethrow;
    }
  }

  /// 批量获取谱面数据
  /// [songId] 曲目ID
  /// [difficulties] 难度列表，默认获取所有难度
  Future<Map<String, PhigrosChart>> fetchCharts(
    String songId, {
    List<String>? difficulties,
  }) async {
    final diffList = difficulties ?? ['EZ', 'HD', 'IN', 'AT'];
    final charts = <String, PhigrosChart>{};

    for (final diff in diffList) {
      try {
        final chart = await fetchChart(songId, diff);
        charts[diff] = chart;
      } catch (e) {
        print('⚠️ 跳过难度 $diff: $e');
      }
    }

    return charts;
  }
}
