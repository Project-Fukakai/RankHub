import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/phigros/viewmodels/phigros_view_model.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/song.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/phigros/pages/song_detail_page.dart';

/// Phigros 成绩列表项
class PhigrosRecordListItem extends ConsumerWidget {
  final PhigrosGameRecord? record;

  const PhigrosRecordListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = this.record;
    // 强制使用深色主题
    final colorScheme = ColorScheme.dark();
    final textTheme = Theme.of(context).textTheme;
    final isDark = true; // 固定为深色模式

    // 获取曲绘URL
    final illustrationUrl = record != null
        ? 'https://ghfast.top/https://raw.githubusercontent.com/7aGiven/Phigros_Resource/refs/heads/illustrationLowRes/${record.songId}.png'
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      clipBehavior: Clip.hardEdge,
      color: colorScheme.surface, // 使用深色主题的surface颜色
      child: InkWell(
        onTap: record != null
            ? () {
                // 从 controller 查找对应的 song
                final songs = ref.read(phigrosViewModelProvider).songs;
                PhigrosSong? song;
                for (final item in songs) {
                  if (item.songId == record.songId) {
                    song = item;
                    break;
                  }
                }

                if (song != null) {
                  pushDetailPage(
                    context,
                    PhigrosSongDetailPage(song: song),
                  );
                } else {
                  // 如果找不到歌曲，显示提示
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('未找到对应的歌曲信息')));
                }
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // 曲绘背景 - 最底层
            if (illustrationUrl != null)
              _buildIllustrationBackground(illustrationUrl),
            // 大字评级背景
            if (record != null) _buildRatingBackground(record, isDark),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // 难度颜色指示器
                  Container(
                    width: 4,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(record?.level ?? "", isDark),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 成绩信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record?.songName ?? "暂无成绩信息",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record?.artist ?? "",
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        if (record != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildDifficultyRksChip(
                                record.level,
                                record.constant,
                                record.rks,
                                _getDifficultyColor(record.level, isDark),
                              ),
                              if (record.fc)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.amber.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Text(
                                    'FC',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              _buildRksIncreaseChip(ref, record),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 右侧ACC和分数
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(record?.acc ?? 0).toStringAsFixed(2)}%',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record?.score.toString() ?? "000000",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String level, bool isDark) {
    switch (level) {
      case 'EZ':
        return Colors.green;
      case 'HD':
        return Colors.blue;
      case 'IN':
        return Colors.red;
      case 'AT':
        return isDark ? Colors.white : Colors.black;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDifficultyRksChip(
    String level,
    double constant,
    double rks,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            level,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            constant.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.arrow_forward,
              size: 10,
              color: color.withValues(alpha: 0.6),
            ),
          ),
          Text(
            rks.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(String rating, bool isBlueV) {
    if (rating == 'ϕ') return Colors.amber; // Phi
    if (rating == 'V') {
      return isBlueV ? Colors.blue : Colors.grey.shade300; // 蓝V vs 白V
    }
    if (rating == 'S') return Colors.purple;
    if (rating == 'A') return Colors.blue;
    if (rating == 'B') return Colors.green;
    if (rating == 'C') return Colors.orange;
    if (rating == 'F') return Colors.red;
    return Colors.grey;
  }

  Widget _buildRksIncreaseChip(WidgetRef ref, PhigrosGameRecord record) {
    try {
      final viewModel = ref.read(phigrosViewModelProvider.notifier);
      final b30 = viewModel.getB30Records();
      final allB30 = [...(b30['phi'] ?? []), ...(b30['best'] ?? [])];
      final isInB30 = allB30.any((r) => r.id == record.id);

      if (!isInB30) return const SizedBox.shrink();

      final requiredAcc = viewModel.calculateRequiredAccForRksIncrease(
        record,
        true,
      );

      if (requiredAcc == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_upward, size: 10, color: Colors.green),
            const SizedBox(width: 2),
            Text(
              '${requiredAcc.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildIllustrationBackground(String illustrationUrl) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.2,
        child: CachedNetworkImage(
          imageUrl: illustrationUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey.shade900),
          errorWidget: (context, url, error) =>
              Container(color: Colors.grey.shade900),
        ),
      ),
    );
  }

  Widget _buildRatingBackground(PhigrosGameRecord record, bool isDark) {
    final color = _getRatingColor(record.rating, record.isBlueV);

    return Positioned(
      top: -32,
      right: -24,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [Colors.transparent, Colors.white],
            stops: const [0.0, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Text(
          record.rating,
          style: TextStyle(
            fontSize: 160,
            fontWeight: FontWeight.w900,
            color: color.withValues(alpha: 0.8),
            letterSpacing: 2,
            height: 1,
          ),
        ),
      ),
    );
  }
}
