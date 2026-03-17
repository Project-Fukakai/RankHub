import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/pages/song_detail_page.dart'
    as maimai_pages;
import '../services/lxns_api_service.dart';
import 'package:rank_hub/core/detail_navigation.dart';

/// 曲目列表项
class SongListItem extends ConsumerWidget {
  final MaimaiSong song;

  const SongListItem({super.key, required this.song});

  /// 获取难度颜色 - 基于 LevelIndex 枚举
  Color _getDifficultyColor(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return Colors.green;
      case LevelIndex.advanced:
        return Colors.yellow.shade700;
      case LevelIndex.expert:
        return Colors.red;
      case LevelIndex.master:
        return Colors.purple;
      case LevelIndex.reMaster:
        return Colors.purple.shade200;
    }
  }

  /// 构建难度芯片列表
  List<Widget> _buildDifficultyChips(MaimaiSong song, BuildContext context) {
    final List<Widget> chips = [];

    // 添加 Standard 谱面难度
    if (song.difficulties.standard.isNotEmpty) {
      // 按难度排序
      final standardDiffs = List.from(song.difficulties.standard);
      standardDiffs.sort(
        (a, b) => a.difficulty.value.compareTo(b.difficulty.value),
      );

      for (var diff in standardDiffs) {
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getDifficultyColor(diff.difficulty),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              diff.level,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }

    // 添加分隔符(如果两种谱面都存在)
    if (song.difficulties.standard.isNotEmpty &&
        song.difficulties.dx.isNotEmpty) {
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: const Text(
            '|',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // 添加 DX 谱面难度
    if (song.difficulties.dx.isNotEmpty) {
      // 按难度排序
      final dxDiffs = List.from(song.difficulties.dx);
      dxDiffs.sort((a, b) => a.difficulty.value.compareTo(b.difficulty.value));

      for (var diff in dxDiffs) {
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getDifficultyColor(diff.difficulty),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              diff.level,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }

    return chips.isEmpty ? [const SizedBox.shrink()] : chips;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: LxnsApiService.getJacketUrl(song.songId),
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.music_note, color: colorScheme.onPrimaryContainer),
            ),
          ),
        ),
        title: Text(
          song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _buildDifficultyChips(song, context),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          pushDetailPage(
            context,
            maimai_pages.SongDetailPage(song: song),
          );
        },
      ),
    );
  }
}
