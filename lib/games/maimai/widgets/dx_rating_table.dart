import 'package:flutter/material.dart';

/// DX Rating 分数表
class DxRatingTable extends StatelessWidget {
  final double levelValue; // 谱面定数
  final double? currentAchievement; // 当前达成率（可选）

  const DxRatingTable({
    super.key,
    required this.levelValue,
    this.currentAchievement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 定义达成率阶段
    final stages = _generateRatingStages();

    // 计算当前达成率对应的 Rating
    // ignore: unused_local_variable
    int? currentRating;
    if (currentAchievement != null) {
      // 找到适用的系数
      double factor = 0.0;
      for (final stage in stages) {
        if (currentAchievement! >= stage['minAchievement']) {
          factor = stage['factor'] as double;
          break;
        }
      }
      currentRating = _calculateRating(currentAchievement!, factor);
    }

    // 找出当前达成率所在的阶段
    int? currentStageIndex;
    if (currentAchievement != null) {
      // 从高到低遍历，找到第一个小于等于当前达成率的阶段
      for (int i = 0; i < stages.length; i++) {
        final stageAchievement = stages[i]['minAchievement'] as double;
        if (currentAchievement! >= stageAchievement) {
          currentStageIndex = i;
          break;
        }
      }
    }

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowHeight: 48,
        dataRowMinHeight: 40,
        dataRowMaxHeight: 48,
        columnSpacing: 16,
        horizontalMargin: 0,
        headingRowColor: WidgetStateProperty.all(
          colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        columns: const [
          DataColumn(
            label: Text('达成率', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('系数', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Rating',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('增加', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: stages.asMap().entries.map((entry) {
          final index = entry.key;
          final stage = entry.value;
          final isCurrentStage = currentStageIndex == index;

          final minAchievement = stage['minAchievement'] as double;
          final factor = stage['factor'] as double;
          final rating = _calculateRating(minAchievement, factor);

          // 计算与上一阶段的增量
          String increment = '';
          if (index > 0) {
            final prevStage = stages[index - 1];
            final prevRating = _calculateRating(
              prevStage['minAchievement'] as double,
              prevStage['factor'] as double,
            );
            final diff = rating - prevRating;
            // 只显示正增量，负数和0都不显示
            if (diff > 0) {
              increment = '+$diff';
            } else {
              increment = '-';
            }
          } else {
            increment = '-';
          }

          return DataRow(
            color: isCurrentStage
                ? WidgetStateProperty.all(
                  colorScheme.primaryContainer.withValues(alpha: 0.3),
                )
                : null,
            cells: [
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatAchievement(minAchievement),
                      style: TextStyle(
                        fontWeight: isCurrentStage
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (isCurrentStage) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_left,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
              DataCell(
                Text(
                  factor.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: isCurrentStage
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              DataCell(
                Text(
                  rating.toString(),
                  style: TextStyle(
                    fontWeight: isCurrentStage
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isCurrentStage ? colorScheme.primary : null,
                  ),
                ),
              ),
              DataCell(
                Text(
                  increment,
                  style: TextStyle(
                    fontWeight: isCurrentStage
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: increment.startsWith('+')
                        ? Colors.green
                        : (increment == '-' ? Colors.grey : Colors.red),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 生成 97% 以上的达成率阶段
  List<Map<String, dynamic>> _generateRatingStages() {
    return [
      {'minAchievement': 100.5000, 'factor': 22.4},
      {'minAchievement': 100.4999, 'factor': 22.2},
      {'minAchievement': 100.0000, 'factor': 21.6},
      {'minAchievement': 99.9999, 'factor': 21.4},
      {'minAchievement': 99.5000, 'factor': 21.1},
      {'minAchievement': 99.0000, 'factor': 20.8},
      {'minAchievement': 98.9999, 'factor': 20.6},
      {'minAchievement': 98.0000, 'factor': 20.3},
      {'minAchievement': 97.0000, 'factor': 20.0},
    ];
  }

  /// 计算 Rating
  int _calculateRating(double achievement, double factor) {
    return (levelValue * achievement * factor / 100).floor();
  }

  /// 格式化达成率显示
  String _formatAchievement(double achievement) {
    if (achievement >= 100.0) {
      return '${achievement.toStringAsFixed(4)}%';
    } else {
      return '${achievement.toStringAsFixed(4)}%';
    }
  }
}
