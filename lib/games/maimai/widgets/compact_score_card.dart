import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/fc_type.dart';
import 'package:rank_hub/games/maimai/models/enums/fs_type.dart';
import 'package:rank_hub/games/maimai/viewmodels/maimai_song_view_model.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/maimai/pages/song_detail_page.dart'
    as maimai_pages;

/// 紧凑型成绩卡片 - 用于 B50 列表
class CompactScoreCard extends ConsumerWidget {
  final MaimaiScore score;
  final int? rank; // 可选的排名显示

  const CompactScoreCard(this.score, {super.key, this.rank});

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
        return const Color.fromARGB(255, 7, 102, 245);
      case 'dx':
        return const Color.fromARGB(255, 224, 193, 23);
      default:
        return Colors.grey;
    }
  }

  /// 获取 FC 颜色
  Color? _getFcColor(FCType? fc) {
    if (fc == null) return null;
    switch (fc) {
      case FCType.fc:
        return const Color.fromARGB(255, 49, 202, 151);
      case FCType.fcPlus:
        return const Color(0xFF4CAF50);
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
        return const Color.fromARGB(255, 25, 50, 196);
      case FSType.fsd:
        return const Color(0xFFE91E63);
      case FSType.fsdPlus:
        return const Color(0xFFF44336);
      case FSType.sync:
        return const Color.fromARGB(255, 92, 129, 147);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementStr = score.achievements.toStringAsFixed(4);
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
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // 查找对应的曲目并跳转到详情页
          final songState = ref.read(maimaiSongViewModelProvider);
          final song = songState.allSongs.firstWhereOrNull(
            (s) => s.songId == score.songId,
          );
          if (song != null) {
            pushDetailPage(
              context,
              maimai_pages.SongDetailPage(song: song),
            );
          }
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 封面图
              SizedBox(
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
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
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              // 内容区域
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 第一行：曲名 + Rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              score.songName,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              score.dxRating
                                  .truncateToDouble()
                                  .toInt()
                                  .toString(),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // 第二行：难度 + 类型 + 达成率
                      Row(
                        children: [
                          // 难度
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: levelColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "${score.levelIndex.label} ${score.level}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // 类型
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              score.type.name == 'standard' ? '标准' : 'DX',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // 达成率
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: intPart,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '.$decimalPart%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // 第三行：FC/FS 徽章
                      Row(
                        children: [
                          if (score.fc != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: fcColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                score.fc!.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (score.fc != null && score.fs != null)
                            const SizedBox(width: 4),
                          if (score.fs != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: fsColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                score.fs!.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const Spacer(),
                          // DX Score
                          Text(
                            "DX: ${score.dxScore}",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
