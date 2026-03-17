import 'package:flutter/material.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/enums/rate_type.dart';
import 'dx_score_progress.dart';

/// 当前成绩卡片
class CurrentScoreCard extends StatelessWidget {
  final MaimaiScore score;
  final int maxDxScore;

  const CurrentScoreCard({
    super.key,
    required this.score,
    required this.maxDxScore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              '当前成绩',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 达成率
            Row(
              children: [
                // 评级图标
                if (score.rate != null)
                  Image.network(
                    'https://maimai.lxns.net/assets/maimai/music_rank/${score.rate!.value}.webp',
                    width: 100,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getRankColor(score.rate!).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getRankColor(score.rate!),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          score.rate!.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getRankColor(score.rate!),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(width: 12),
                // 达成率分数（整数和小数分开显示）
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: score.achievements.floor().toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            '.${(score.achievements * 10000 % 10000).floor().toString().padLeft(4, '0')}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            // FC/FS 状态
            Row(
              children: [
                if (score.fc != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        39,
                        176,
                        112,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple, width: 1.5),
                    ),
                    child: Text(
                      score.fc!.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 44, 205, 149),
                      ),
                    ),
                  ),
                if (score.fc != null && score.fs != null)
                  const SizedBox(width: 8),
                if (score.fs != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 1.5),
                    ),
                    child: Text(
                      score.fs!.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                if (score.fc == null && score.fs == null)
                  Text(
                    '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // DX Rating
            Row(
              children: [
                Text(
                  'DX Rating',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  score.dxRating.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // DX Score
            DxScoreProgress(
              currentDxScore: score.dxScore,
              totalNotes: maxDxScore ~/ 3,
            ),
          ],
        ),
      ),
    );
  }

  /// 根据评级获取颜色
  Color _getRankColor(RateType rank) {
    switch (rank) {
      case RateType.sssPlus:
        return Colors.purple;
      case RateType.sss:
        return Colors.deepPurple;
      case RateType.ssPlus:
        return Colors.amber;
      case RateType.ss:
        return Colors.orange;
      case RateType.sPlus:
        return Colors.yellow.shade700;
      case RateType.s:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
