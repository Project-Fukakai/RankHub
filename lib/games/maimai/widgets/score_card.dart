import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/fc_type.dart';
import 'package:rank_hub/games/maimai/models/enums/fs_type.dart';

/// 成绩卡片组件
class ScoreCard extends StatelessWidget {
  final MaimaiScore score;

  const ScoreCard(this.score, {super.key});

  /// 获取难度颜色
  Color _getLevelColor(LevelIndex levelIndex) {
    switch (levelIndex) {
      case LevelIndex.basic:
        return const Color(0xFF22BB5B);
      case LevelIndex.advanced:
        return const Color(0xFFFF9900);
      case LevelIndex.expert:
        return const Color(0xFFEE0000);
      case LevelIndex.master:
        return const Color(0xFFBB33EE);
      case LevelIndex.reMaster:
        return const Color(0xFFDDAAFF);
    }
  }

  /// 获取谱面类型颜色
  Color _getTypeColor(String type) {
    switch (type) {
      case 'standard':
        return const Color(0xFF4CAF50);
      case 'dx':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  /// 获取 FC 颜色
  Color? _getFcColor(FCType? fc) {
    if (fc == null) return null;
    switch (fc) {
      case FCType.fc:
        return const Color(0xFF4CAF50);
      case FCType.fcPlus:
        return const Color(0xFFFFEB3B);
      case FCType.ap:
        return const Color(0xFFFF9800);
      case FCType.apPlus:
        return const Color(0xFFFF5722);
    }
  }

  /// 获取 FS 颜色
  Color? _getFsColor(FSType? fs) {
    if (fs == null) return null;
    switch (fs) {
      case FSType.fs:
        return const Color(0xFF03A9F4);
      case FSType.fsPlus:
        return const Color(0xFF9C27B0);
      case FSType.fsd:
        return const Color(0xFFE91E63);
      case FSType.fsdPlus:
        return const Color(0xFFF44336);
      case FSType.sync:
        return const Color(0xFF607D8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 直接使用原始值，不做四舍五入或截断
    final achievementStr = score.achievements.toString();
    final parts = achievementStr.split('.');
    final intPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '0';

    final imageUrl =
        "https://assets2.lxns.net/maimai/jacket/${score.songId}.png";
    final levelColor = _getLevelColor(score.levelIndex);
    final typeColor = _getTypeColor(score.type.name);
    final fcColor = _getFcColor(score.fc);
    final fsColor = _getFsColor(score.fs);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Opacity(
                opacity: 0.4,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 500),
                  placeholder: (context, url) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.music_note,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 内容
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 曲名
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        score.songName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 难度和类型标签
                Row(
                  children: [
                    Chip(
                      side: const BorderSide(width: 0),
                      label: Text(
                        "${score.levelIndex.label} ${score.level}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: levelColor,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      labelPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      side: const BorderSide(width: 0),
                      label: Text(
                        score.type.name == 'standard' ? '标准' : 'DX',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: typeColor,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      labelPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 达成率和徽章
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: intPart,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '.$decimalPart%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (score.fc != null)
                      Chip(
                        side: const BorderSide(width: 0),
                        label: Text(
                          score.fc!.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: fcColor,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        labelPadding: EdgeInsets.zero,
                      ),
                    if (score.fc != null && score.fs != null)
                      const SizedBox(width: 8),
                    if (score.fs != null)
                      Chip(
                        side: const BorderSide(width: 0),
                        label: Text(
                          score.fs!.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: fsColor,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        labelPadding: EdgeInsets.zero,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // DX Score 和 Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DX Score: ${score.dxScore}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "Rating: ${score.dxRating.truncateToDouble().toInt()}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
