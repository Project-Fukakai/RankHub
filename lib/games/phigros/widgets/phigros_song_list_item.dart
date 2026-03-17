import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/models/phigros/song.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/phigros/pages/song_detail_page.dart';

/// Phigros 曲目列表项
class PhigrosSongListItem extends ConsumerWidget {
  final PhigrosSong song;

  const PhigrosSongListItem({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {
          pushDetailPage(
            context,
            PhigrosSongDetailPage(song: song),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 曲绘
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: song.illustrationLowResUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.music_note),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 曲目信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.composer,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((song.chapter ?? '').isNotEmpty &&
                        song.chapter != '--') ...[
                      const SizedBox(height: 4),
                      Text(
                        song.chapter!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    // 难度信息 - 使用Wrap自动换行
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (song.difficultyEZ != null && song.difficultyEZ! > 0)
                          _buildDifficultyChip(
                            context,
                            'EZ',
                            song.difficultyEZ!,
                            Colors.green,
                          ),
                        if (song.difficultyHD != null && song.difficultyHD! > 0)
                          _buildDifficultyChip(
                            context,
                            'HD',
                            song.difficultyHD!,
                            Colors.blue,
                          ),
                        if (song.difficultyIN != null && song.difficultyIN! > 0)
                          _buildDifficultyChip(
                            context,
                            'IN',
                            song.difficultyIN!,
                            Colors.red,
                          ),
                        if (song.difficultyAT != null && song.difficultyAT! > 0)
                          _buildDifficultyChip(
                            context,
                            'AT',
                            song.difficultyAT!,
                            null, // AT使用特殊处理
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(
    BuildContext context,
    String level,
    double difficulty,
    Color? color,
  ) {
    // AT难度特殊处理：深色模式用白色，浅色模式用黑色
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? (isDark ? Colors.white : Colors.black);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: effectiveColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: effectiveColor),
          const SizedBox(width: 4),
          Text(
            level,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            difficulty.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: effectiveColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
