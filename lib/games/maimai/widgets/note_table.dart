import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:rank_hub/games/maimai/models/maimai_notes.dart';

/// 物量表格组件
class NoteTable extends StatelessWidget {
  final MaimaiNotes notes;
  final int calculateMode;

  const NoteTable({
    super.key,
    required this.notes,
    required this.calculateMode,
  });

  /// 计算总权重
  double _calculateTotalWeight() {
    return notes.tap.toDouble() +
        notes.touch.toDouble() +
        2 * notes.hold.toDouble() +
        3 * notes.slide.toDouble() +
        5 * notes.breakNote.toDouble();
  }

  /// 计算所有结果
  Map<String, Map<String, String>> _calculateResults() {
    final totalWeight = _calculateTotalWeight();
    final x = 1 / totalWeight;
    final y = notes.breakNote > 0 ? 1 / notes.breakNote : 0.0;

    return _generateResults(notes, x, y, calculateMode);
  }

  /// 生成结果
  Map<String, Map<String, String>> _generateResults(
    MaimaiNotes notes,
    double x,
    double y,
    int mode,
  ) {
    return {
      "TAP": _generateEntry(notes.tap, 1, 1, x, mode, 0.8, 0.5),
      "HOLD": _generateEntry(notes.hold, 2, 2, x, mode, 1.6, 1),
      "SLIDE": _generateEntry(notes.slide, 3, 3, x, mode, 2.4, 2),
      "TOUCH": _generateEntry(notes.touch, 1, 1, x, mode, 0.8, 1),
      "BREAK": _generateBreakEntry(notes.breakNote, x, y, mode),
    };
  }

  /// 生成普通note条目
  Map<String, String> _generateEntry(
    int count,
    double criticalFactor,
    double perfectFactor,
    double x,
    int mode,
    double greatFactor,
    double goodFactor,
  ) {
    if (count == 0) {
      return {
        "数量": "0",
        "CRITICAL": "-",
        "PERFECT": "-",
        "GREAT": "-",
        "GOOD": "-",
        "MISS": "-",
      };
    }

    double criticalScore = criticalFactor * x * 100;
    double perfectScore = perfectFactor * x * 100;

    String calculate(double factor) {
      double value = factor * x * 100;
      if (mode == 1) {
        value -= criticalScore;
      } else if (mode == 2) {
        value -= perfectScore;
      }
      return value.toStringAsFixed(4);
    }

    return {
      "数量": count.toString(),
      "CRITICAL": "${calculate(criticalFactor)}%",
      "PERFECT": "${calculate(perfectFactor)}%",
      "GREAT": "${calculate(greatFactor)}%",
      "GOOD": "${calculate(goodFactor)}%",
      "MISS": "${calculate(0)}%",
    };
  }

  /// 生成BREAK条目
  Map<String, String> _generateBreakEntry(
    int count,
    double x,
    double y,
    int mode,
  ) {
    if (count == 0) {
      return {
        "数量": "0",
        "CRITICAL": "-",
        "PERFECT": "-",
        "GREAT": "-",
        "GOOD": "-",
        "MISS": "-",
      };
    }

    double criticalScore = 5 * x * 100 + y;
    double perfectScore = 5 * x * 100 + 0.75 * y;

    String calculateBreak(double baseFactor, double additionalFactor) {
      double value = baseFactor * x * 100 + additionalFactor * y;

      if (mode == 1) {
        value -= criticalScore;
      } else if (mode == 2) {
        value -= perfectScore;
      }
      return value.toStringAsFixed(4);
    }

    return {
      "数量": count.toString(),
      "CRITICAL": "${calculateBreak(5, 1)}%",
      "PERFECT": "${calculateBreak(5, 0.75)}%\n${calculateBreak(5, 0.5)}%",
      "GREAT":
          "${calculateBreak(4, 0.4)}%\n${calculateBreak(3, 0.4)}%\n${calculateBreak(2.5, 0.4)}%",
      "GOOD": "${calculateBreak(2, 0.3)}%",
      "MISS": "${calculateBreak(0, 0)}%",
    };
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculateResults();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 0,
            minWidth: 800,
            fixedLeftColumns: 1,
            headingRowHeight: 40,
            dataRowHeight: 48,
            columns: [
              DataColumn2(
                label: Text(
                  '类型',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                size: ColumnSize.S,
                fixedWidth: 80,
              ),
              DataColumn2(
                label: Text(
                  '数量',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                size: ColumnSize.S,
                fixedWidth: 60,
              ),
              DataColumn2(
                label: Text(
                  'CRITICAL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade800,
                  ),
                ),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(
                  'PERFECT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(
                  'GREAT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(
                  'GOOD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text(
                  'MISS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                size: ColumnSize.M,
              ),
            ],
            rows: [
              _buildDataRow('TAP', results['TAP']!, false),
              _buildDataRow('HOLD', results['HOLD']!, false),
              _buildDataRow('SLIDE', results['SLIDE']!, false),
              if (notes.touch > 0)
                _buildDataRow('TOUCH', results['TOUCH']!, false),
              _buildDataRow('BREAK', results['BREAK']!, true),
            ],
          ),
        ),
        // 滑动提示
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                '左右滑动查看更多',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建数据行
  DataRow2 _buildDataRow(String type, Map<String, String> data, bool isBreak) {
    return DataRow2(
      specificRowHeight: isBreak ? 100 : null,
      cells: [
        DataCell(
          Text(type, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        DataCell(Text(data['数量']!)),
        DataCell(
          Text(
            data['CRITICAL']!,
            style: TextStyle(color: Colors.yellow.shade800),
          ),
        ),
        DataCell(
          Text(
            data['PERFECT']!,
            style: TextStyle(color: Colors.orange.shade800),
          ),
        ),
        DataCell(
          Text(data['GREAT']!, style: const TextStyle(color: Colors.pink)),
        ),
        DataCell(
          Text(data['GOOD']!, style: const TextStyle(color: Colors.green)),
        ),
        DataCell(
          Text(data['MISS']!, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
