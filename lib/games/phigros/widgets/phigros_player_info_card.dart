import 'package:flutter/material.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/player_summary.dart';

/// Phigros 玩家信息卡片
class PhigrosPlayerInfoCard extends StatelessWidget {
  final List<PhigrosGameRecord> records;
  final PhigrosPlayerSummary? summary;

  const PhigrosPlayerInfoCard({super.key, required this.records, this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 计算统计数据
    final stats = _calculateStats(records);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RKS 信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RKS',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats.totalRks.toStringAsFixed(2),
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'B19 平均',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats.b19AverageRks.toStringAsFixed(2),
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // 挑战模式信息
            if (summary != null && summary!.challengeModeRank > 0) ...[
              Row(
                children: [
                  Icon(
                    Icons.military_tech,
                    color: _getChallengeColor(summary!.challengeRankLevel),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '挑战模式',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getChallengeColor(
                        summary!.challengeRankLevel,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getChallengeColor(summary!.challengeRankLevel),
                      ),
                    ),
                    child: Text(
                      summary!.challengeRankDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getChallengeColor(summary!.challengeRankLevel),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],
            // 统计信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Phi',
                  stats.phiCount.toString(),
                  Colors.amber,
                ),
                _buildStatItem(
                  context,
                  'FC',
                  stats.fcCount.toString(),
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'AP',
                  stats.apCount.toString(),
                  Colors.pink,
                ),
                _buildStatItem(
                  context,
                  'CLEAR',
                  stats.totalSongsPlayed.toString(),
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 难度统计
            Row(
              children: [
                Expanded(
                  child: _buildDifficultyBar(
                    context,
                    'EZ',
                    stats.ezCount,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDifficultyBar(
                    context,
                    'HD',
                    stats.hdCount,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDifficultyBar(
                    context,
                    'IN',
                    stats.inCount,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDifficultyBar(
                    context,
                    'AT',
                    stats.atCount,
                    Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 从记录列表计算统计数据
  _PlayerStats _calculateStats(List<PhigrosGameRecord> records) {
    // 计算B19（Best 19，取RKS最高的19首）
    final sortedRecords = List<PhigrosGameRecord>.from(records)
      ..sort((a, b) => b.rks.compareTo(a.rks));

    final b19Records = sortedRecords.take(19).toList();
    final b19Sum = b19Records.fold<double>(
      0.0,
      (sum, record) => sum + record.rks,
    );
    final b19Average = b19Records.isNotEmpty ? b19Sum / b19Records.length : 0.0;

    // 统计各种数据
    int phiCount = 0; // 满分（100w分）
    int fcCount = 0; // Full Combo（包括满分）
    int apCount = 0; // All Perfect（准确率100%，即使不满分）
    int ezCount = 0;
    int hdCount = 0;
    int inCount = 0;
    int atCount = 0;

    // 按难度分别统计 CLEAR, AP, FC, PHI
    Map<String, int> clearByDifficulty = {'EZ': 0, 'HD': 0, 'IN': 0, 'AT': 0};
    Map<String, int> apByDifficulty = {'EZ': 0, 'HD': 0, 'IN': 0, 'AT': 0};
    Map<String, int> fcByDifficulty = {'EZ': 0, 'HD': 0, 'IN': 0, 'AT': 0};
    Map<String, int> phiByDifficulty = {'EZ': 0, 'HD': 0, 'IN': 0, 'AT': 0};

    for (final record in records) {
      // 满分
      if (record.score >= 1000000) phiCount++;
      // FC（Full Combo）
      if (record.fc) fcCount++;
      // AP（All Perfect，准确率100%）
      if (record.acc >= 100.0) apCount++;

      // 按难度统计
      final level = record.level;
      if (['EZ', 'HD', 'IN', 'AT'].contains(level)) {
        // CLEAR 统计
        clearByDifficulty[level] = (clearByDifficulty[level] ?? 0) + 1;

        // AP 统计
        if (record.acc >= 100.0) {
          apByDifficulty[level] = (apByDifficulty[level] ?? 0) + 1;
        }

        // FC 统计
        if (record.fc) {
          fcByDifficulty[level] = (fcByDifficulty[level] ?? 0) + 1;
        }

        // PHI 统计（满分）
        if (record.score >= 1000000) {
          phiByDifficulty[level] = (phiByDifficulty[level] ?? 0) + 1;
        }

        // 总数统计
        switch (level) {
          case 'EZ':
            ezCount++;
            break;
          case 'HD':
            hdCount++;
            break;
          case 'IN':
            inCount++;
            break;
          case 'AT':
            atCount++;
            break;
        }
      }
    }

    return _PlayerStats(
      totalRks: b19Average,
      b19AverageRks: b19Average,
      phiCount: phiCount,
      fcCount: fcCount,
      apCount: apCount,
      totalSongsPlayed: records.length,
      ezCount: ezCount,
      hdCount: hdCount,
      inCount: inCount,
      atCount: atCount,
      clearByDifficulty: clearByDifficulty,
      apByDifficulty: apByDifficulty,
      fcByDifficulty: fcByDifficulty,
      phiByDifficulty: phiByDifficulty,
    );
  }

  Color _getChallengeColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      case 4:
        return Colors.amber;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBar(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// 玩家统计数据辅助类
class _PlayerStats {
  final double totalRks;
  final double b19AverageRks;
  final int phiCount;
  final int fcCount;
  final int apCount;
  final int totalSongsPlayed;
  final int ezCount;
  final int hdCount;
  final int inCount;
  final int atCount;
  final Map<String, int> clearByDifficulty;
  final Map<String, int> apByDifficulty;
  final Map<String, int> fcByDifficulty;
  final Map<String, int> phiByDifficulty;

  _PlayerStats({
    required this.totalRks,
    required this.b19AverageRks,
    required this.phiCount,
    required this.fcCount,
    required this.apCount,
    required this.totalSongsPlayed,
    required this.ezCount,
    required this.hdCount,
    required this.inCount,
    required this.atCount,
    required this.clearByDifficulty,
    required this.apByDifficulty,
    required this.fcByDifficulty,
    required this.phiByDifficulty,
  });
}
