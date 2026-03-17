import 'package:flutter/material.dart';

/// DX Score 进度条组件
class DxScoreProgress extends StatelessWidget {
  final int currentDxScore; // 当前 DX 分数
  final int totalNotes; // 总物量

  const DxScoreProgress({
    super.key,
    required this.currentDxScore,
    required this.totalNotes,
  });

  @override
  Widget build(BuildContext context) {
    // 计算最大 DX 分数（总物量 × 3）
    final maxDxScore = totalNotes * 3;

    // 计算百分比
    final percentage = maxDxScore > 0
        ? (currentDxScore / maxDxScore) * 100
        : 0.0;

    // 计算星级
    final stars = _calculateStars(percentage);

    // 根据星级获取颜色
    final color = _getColorByStars(stars);

    // 计算距离下一阶段所需
    final nextStarInfo = _calculateNextStarInfo(percentage, maxDxScore);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'DX Score',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$currentDxScore / $maxDxScore',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${percentage.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (stars > 0) ...[
              const SizedBox(width: 4),
              Text("✦", style: TextStyle(fontSize: 14, color: color)),
              Text(
                '$stars',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ],
        ),
        if (nextStarInfo != null) ...[
          const SizedBox(height: 4),
          Text(
            '距离${nextStarInfo['nextStars']}星还需: ${nextStarInfo['needed']} (${nextStarInfo['nextPercentage']}%)',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          ),
        ],
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _calculateProgressValue(percentage),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  /// 计算星级
  int _calculateStars(double percentage) {
    if (percentage >= 97.0) return 5;
    if (percentage >= 95.0) return 4;
    if (percentage >= 93.0) return 3;
    if (percentage >= 90.0) return 2;
    if (percentage >= 85.0) return 1;
    return 0;
  }

  /// 计算进度条值（85%-100%区间映射到0-1）
  double _calculateProgressValue(double percentage) {
    if (percentage < 85.0) return 0.0;
    if (percentage >= 100.0) return 1.0;
    // 将 85%-100% 映射到 0-1
    return (percentage - 85.0) / 15.0;
  }

  /// 根据星级获取颜色
  Color _getColorByStars(int stars) {
    switch (stars) {
      case 5:
        return Colors.amber; // 黄色 ✦5
      case 4:
      case 3:
        return Colors.orange; // 橙色 ✦3-4
      case 2:
      case 1:
        return Colors.green; // 绿色 ✦1-2
      default:
        return Colors.grey; // 灰色 无星
    }
  }

  /// 计算距离下一阶段所需信息
  Map<String, dynamic>? _calculateNextStarInfo(
    double currentPercentage,
    int maxDxScore,
  ) {
    double? nextPercentage;
    int? nextStars;

    if (currentPercentage < 85.0) {
      nextPercentage = 85.0;
      nextStars = 1;
    } else if (currentPercentage < 90.0) {
      nextPercentage = 90.0;
      nextStars = 2;
    } else if (currentPercentage < 93.0) {
      nextPercentage = 93.0;
      nextStars = 3;
    } else if (currentPercentage < 95.0) {
      nextPercentage = 95.0;
      nextStars = 4;
    } else if (currentPercentage < 97.0) {
      nextPercentage = 97.0;
      nextStars = 5;
    }

    if (nextPercentage == null || nextStars == null) {
      return null; // 已达到最高星级
    }

    // 计算需要的 DX Score
    final neededDxScore =
        ((nextPercentage / 100) * maxDxScore).ceil() - currentDxScore;

    return {
      'nextStars': nextStars,
      'nextPercentage': nextPercentage.toStringAsFixed(0),
      'needed': neededDxScore > 0 ? neededDxScore : 0,
    };
  }
}
