import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';
import 'package:share_plus/share_plus.dart';

/// 舞萌DX 成绩数据导出服务
class MaimaiExportService {
  static final MaimaiExportService _instance = MaimaiExportService._();
  MaimaiExportService._();
  static MaimaiExportService get instance => _instance;

  final _isarService = MaimaiIsarService.instance;

  /// 显示导出选项对话框
  Future<void> showExportDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('导出为 CSV'),
              subtitle: const Text('表格格式，适合在 Excel 中查看'),
              onTap: () {
                Navigator.pop(context);
                exportToCSV(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('导出为 JSON'),
              subtitle: const Text('结构化数据格式'),
              onTap: () {
                Navigator.pop(context);
                exportToJSON(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// 导出成绩为 CSV 格式
  Future<void> exportToCSV(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在准备导出数据...')),
      );

      // 获取所有成绩
      final scores = await _isarService.getAllScoresSortedByRating();
      if (scores.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('暂无成绩数据可导出')),
          );
        }
        return;
      }

      // 生成 CSV 内容
      final csvContent = _generateCSV(scores);

      // 保存并分享文件
      await _saveAndShareFile(csvContent, 'maimai_scores.csv', 'text/csv');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('成绩数据已导出（${scores.length} 条）')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    }
  }

  /// 导出成绩为 JSON 格式
  Future<void> exportToJSON(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在准备导出数据...')),
      );

      // 获取所有成绩
      final scores = await _isarService.getAllScoresSortedByRating();
      if (scores.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('暂无成绩数据可导出')),
          );
        }
        return;
      }

      // 生成 JSON 内容
      final jsonContent = _generateJSON(scores);

      // 保存并分享文件
      await _saveAndShareFile(
        jsonContent,
        'maimai_scores.json',
        'application/json',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('成绩数据已导出（${scores.length} 条）')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e')),
        );
      }
    }
  }

  /// 生成 CSV 内容
  String _generateCSV(List<MaimaiScore> scores) {
    final buffer = StringBuffer();

    // CSV 表头
    buffer.writeln(
      'id,song_name,level,level_index,achievements,fc,fs,dx_score,dx_rating,rate,song_type,upload_time,play_time',
    );

    // 写入每条成绩
    for (final score in scores) {
      final row = [
        score.songId.toString(),
        _escapeCsvField(score.songName),
        _escapeCsvField(score.level),
        score.levelIndex.value.toString(),
        score.achievements.toStringAsFixed(4),
        score.fc?.value.toString() ?? '',
        score.fs?.value.toString() ?? '',
        score.dxScore.toString(),
        score.dxRating.toStringAsFixed(1),
        score.rate?.value.toString() ?? '',
        score.type.value.toString(),
        score.uploadTime ?? '',
        score.playTime ?? '',
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  /// 生成 JSON 内容
  String _generateJSON(List<MaimaiScore> scores) {
    final data = {
      'export_time': DateTime.now().toIso8601String(),
      'total_count': scores.length,
      'scores': scores
          .map(
            (score) => {
              'id': score.songId,
              'song_name': score.songName,
              'level': score.level,
              'level_index': score.levelIndex.value,
              'achievements': score.achievements,
              'fc': score.fc?.value,
              'fs': score.fs?.value,
              'dx_score': score.dxScore,
              'dx_rating': score.dxRating,
              'rate': score.rate?.value,
              'song_type': score.type.value,
              'upload_time': score.uploadTime,
              'play_time': score.playTime,
            },
          )
          .toList(),
    };

    // 格式化 JSON，方便阅读
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// 转义 CSV 字段（处理包含逗号、引号、换行符的内容）
  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  /// 保存文件并分享
  Future<void> _saveAndShareFile(
    String content,
    String filename,
    String mimeType,
  ) async {
    try {
      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');

      // 写入文件
      await file.writeAsString(content, encoding: utf8);

      // 使用 share_plus 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '舞萌DX 成绩数据',
        text: '成绩数据导出文件',
        sharePositionOrigin: Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      throw Exception('保存文件失败: $e');
    }
  }
}
