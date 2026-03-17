import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/states/collection_progress_state.dart';

/// 藏品进度卡片
class CollectionProgressCard extends StatelessWidget {
  final CollectionProgress progress;
  final VoidCallback onTap;
  final VoidCallback onUnpin;

  const CollectionProgressCard({
    super.key,
    required this.progress,
    required this.onTap,
    required this.onUnpin,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress.progress * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  Expanded(
                    child: Text(
                      progress.collection.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.push_pin),
                    onPressed: onUnpin,
                    tooltip: '取消固定',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 总谱面进度条
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '谱面: ${progress.completedCharts}/${progress.totalCharts}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.progress,
                      minHeight: 8,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(context, progress.progress),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 各难度进度
              _buildDifficultyProgress(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyProgress(BuildContext context) {
    final difficulties = progress.totalByDifficulty.keys.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    if (difficulties.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: difficulties.map((diff) {
        final total = progress.totalByDifficulty[diff] ?? 0;
        final completed = progress.completedByDifficulty[diff] ?? 0;
        final percentage = total > 0 ? (completed / total * 100).toInt() : 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getDifficultyColor(diff).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _getDifficultyColor(diff).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getDifficultyName(diff),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _getDifficultyColor(diff),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$completed/$total',
                style: TextStyle(
                  fontSize: 11,
                  color: _getDifficultyColor(diff),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                '($percentage%)',
                style: TextStyle(
                  fontSize: 10,
                  color: _getDifficultyColor(diff).withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getDifficultyName(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return 'BAS';
      case LevelIndex.advanced:
        return 'ADV';
      case LevelIndex.expert:
        return 'EXP';
      case LevelIndex.master:
        return 'MAS';
      case LevelIndex.reMaster:
        return 'REM';
    }
  }

  Color _getDifficultyColor(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return Colors.green;
      case LevelIndex.advanced:
        return Colors.orange;
      case LevelIndex.expert:
        return Colors.red;
      case LevelIndex.master:
        return Colors.purple;
      case LevelIndex.reMaster:
        return Colors.deepPurple;
    }
  }

  Color _getProgressColor(BuildContext context, double progress) {
    if (progress >= 1.0) {
      return Colors.green;
    } else if (progress >= 0.7) {
      return Colors.blue;
    } else if (progress >= 0.4) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }
}

/// 整体进度卡片
class OverallProgressCard extends StatelessWidget {
  final CollectionProgress progress;

  const OverallProgressCard({super.key, required this.progress});

  // 获取藏品图片URL
  String? _getCollectionImageUrl() {
    final collection = progress.collection;
    if (collection.collectionType == 'plate') {
      return LxnsApiService.getPlateUrl(collection.collectionId);
    } else if (collection.collectionType == 'frame') {
      return LxnsApiService.getFrameUrl(collection.collectionId);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (progress.progress * 100).toStringAsFixed(1);
    final imageUrl = _getCollectionImageUrl();

    return Card(
      child: Column(
        children: [
          // 藏品图片（仅姓名框和背景）
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 100,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.error_outline)),
                ),
              ),
            ),
          // 原有的进度内容
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左侧：圆形进度
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress.progress,
                        strokeWidth: 10,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(context, progress.progress),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$percentage%',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              '${progress.completedCharts}/${progress.totalCharts}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // 右侧：难度进度条
                Expanded(child: _buildDifficultyProgressBars(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyProgressBars(BuildContext context) {
    // 获取所有有进度的难度
    final difficulties =
        progress.totalByDifficulty.entries
            .where((e) => e.value > 0)
            .map((e) => e.key)
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    return Column(
      children: difficulties.map((difficulty) {
        final total = progress.totalByDifficulty[difficulty] ?? 0;
        final completed = progress.completedByDifficulty[difficulty] ?? 0;
        final diffProgress = total > 0 ? completed / total : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // 难度标签
              SizedBox(
                width: 50,
                child: Text(
                  _getDifficultyShortName(difficulty),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(difficulty),
                  ),
                ),
              ),
              // 进度条
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: diffProgress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(difficulty),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 数量
              SizedBox(
                width: 50,
                child: Text(
                  '$completed/$total',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontSize: 11),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getDifficultyShortName(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return 'BAS';
      case LevelIndex.advanced:
        return 'ADV';
      case LevelIndex.expert:
        return 'EXP';
      case LevelIndex.master:
        return 'MAS';
      case LevelIndex.reMaster:
        return 'Re:MAS';
    }
  }

  Color _getDifficultyColor(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return Colors.green;
      case LevelIndex.advanced:
        return Colors.orange;
      case LevelIndex.expert:
        return Colors.red;
      case LevelIndex.master:
        return Colors.purple;
      case LevelIndex.reMaster:
        return Colors.deepPurple;
    }
  }

  Color _getProgressColor(BuildContext context, double progress) {
    if (progress >= 1.0) {
      return Colors.green;
    } else if (progress >= 0.7) {
      return Colors.blue;
    } else if (progress >= 0.4) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }
}

/// 谱面项（用于不分难度时的展示）
class _ChartItem {
  final SongProgress songProgress;
  final LevelIndex difficulty;

  _ChartItem({required this.songProgress, required this.difficulty});
}

/// 按指定难度分层展示曲目
class TieredSongView extends StatelessWidget {
  final List<SongProgress> songProgresses;
  final LevelIndex? selectedDifficulty; // null表示不筛选

  const TieredSongView({
    super.key,
    required this.songProgresses,
    this.selectedDifficulty,
  });

  @override
  Widget build(BuildContext context) {
    // 如果没有选择难度，按所有谱面的level分组（11+及以上）
    if (selectedDifficulty == null) {
      final Map<String, List<_ChartItem>> tiers =
          _groupAllDifficultiesByLevel();

      // 排序：从高到低
      final sortedLevels = tiers.keys.toList()
        ..sort((a, b) {
          final aNum = double.tryParse(a.replaceAll('+', '.6')) ?? 0;
          final bNum = double.tryParse(b.replaceAll('+', '.6')) ?? 0;
          return bNum.compareTo(aNum);
        });

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final level = sortedLevels[index];
          final List<_ChartItem> items = tiers[level]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 等级标题
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${items.length} 谱面',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // 该难度等级的谱面网格 - 小号正方形
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) {
                    return SongProgressItem(
                      songProgress: item.songProgress,
                      selectedDifficulty: item.difficulty,
                      isCompactMode: true,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }, childCount: sortedLevels.length),
      );
    }

    // 按选中难度的level分组
    final tiers = _groupByLevel();

    // 排序：从高到低
    final sortedLevels = tiers.keys.toList()
      ..sort((a, b) {
        // 处理特殊情况
        if (a == '未知') return 1;
        if (b == '未知') return -1;

        // 提取数字部分进行比较
        final aNum = double.tryParse(a.replaceAll('+', '.7')) ?? 0;
        final bNum = double.tryParse(b.replaceAll('+', '.7')) ?? 0;
        return bNum.compareTo(aNum);
      });

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final level = sortedLevels[index];
        final songs = tiers[level]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 等级标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(
                        selectedDifficulty ?? LevelIndex.master,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${songs.length} 曲',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            // 该难度等级的曲目网格 - 使用小号正方形曲绘
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: songs.map((song) {
                  return SongProgressItem(
                    songProgress: song,
                    selectedDifficulty: selectedDifficulty,
                    isCompactMode: true, // 紧凑模式，小号正方形
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }, childCount: sortedLevels.length),
    );
  }

  Map<String, List<SongProgress>> _groupByLevel() {
    final Map<String, List<SongProgress>> tiers = {};

    for (final song in songProgresses) {
      // 获取指定难度的level字符串
      String? levelStr;

      if (song.songDetail != null && selectedDifficulty != null) {
        final difficulties = song.songDetail!.difficulties;

        // 优先从DX谱面中查找
        for (final diff in difficulties.dx) {
          if (diff.difficulty == selectedDifficulty) {
            levelStr = diff.level;
            break;
          }
        }

        // 如果DX没有，从标准谱面中查找
        if (levelStr == null) {
          for (final diff in difficulties.standard) {
            if (diff.difficulty == selectedDifficulty) {
              levelStr = diff.level;
              break;
            }
          }
        }
      }

      // 如果找不到指定难度，使用"未知"作为默认值
      final level = levelStr ?? '未知';

      if (!tiers.containsKey(level)) {
        tiers[level] = [];
      }
      tiers[level]!.add(song);
    }

    return tiers;
  }

  // 按所有谱面的level分组（11+及以上）
  Map<String, List<_ChartItem>> _groupAllDifficultiesByLevel() {
    final Map<String, List<_ChartItem>> tiers = {};

    for (final song in songProgresses) {
      if (song.songDetail == null) continue;

      final difficulties = song.songDetail!.difficulties;

      // 遍历所有难度的所有谱面
      for (final diff in [...difficulties.dx, ...difficulties.standard]) {
        final level = diff.level;
        if (level.isEmpty) continue;

        // 只显示11+及以上
        final levelNum = double.tryParse(level.replaceAll('+', '.7')) ?? 0;
        if (levelNum < 11.0) continue;

        // 过滤：只显示 requiredDifficulties 中包含的难度
        if (!song.requiredDifficulties.contains(diff.difficulty)) continue;

        if (!tiers.containsKey(level)) {
          tiers[level] = [];
        }

        tiers[level]!.add(
          _ChartItem(songProgress: song, difficulty: diff.difficulty),
        );
      }
    }

    return tiers;
  }

  Color _getDifficultyColor(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return Colors.green;
      case LevelIndex.advanced:
        return Colors.orange;
      case LevelIndex.expert:
        return Colors.red;
      case LevelIndex.master:
        return Colors.purple;
      case LevelIndex.reMaster:
        return Colors.deepPurple;
    }
  }
}

/// 单曲进度项
class SongProgressItem extends StatelessWidget {
  final SongProgress songProgress;
  final LevelIndex? selectedDifficulty; // 当前选中的难度
  final bool isCompactMode; // 是否为紧凑模式（小号正方形）

  const SongProgressItem({
    super.key,
    required this.songProgress,
    this.selectedDifficulty,
    this.isCompactMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final song = songProgress.songDetail;
    final imageUrl = song != null
        ? LxnsApiService.getJacketUrl(song.songId)
        : null;

    // 判断是否完成（基于选中的难度）
    final isCompleted = selectedDifficulty != null
        ? songProgress.completedDifficulties.contains(selectedDifficulty)
        : songProgress.isCompleted;

    // 紧凑模式：小号正方形曲绘
    if (isCompactMode) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selectedDifficulty != null
                ? _getDifficultyColor(selectedDifficulty!)
                : Colors.grey,
            width: 2,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 曲绘
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.music_note, size: 24),
                      ),
                    )
                  : Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.music_note, size: 24),
                    ),
            ),
            // 完成水印
            if (isCompleted)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 24,
                    color: Colors.green.shade300,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // 默认模式：完整卡片
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 曲绘
          if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.music_note),
              ),
            )
          else
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.music_note, size: 48),
            ),

          // 完成水印
          if (isCompleted)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.green.shade300,
                ),
              ),
            ),

          // 底部信息条
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songProgress.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // 只在没有选择难度时显示各难度完成情况
                  if (selectedDifficulty == null) ...[
                    const SizedBox(height: 4),
                    _buildDifficultyIndicators(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyIndicators() {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: songProgress.requiredDifficulties.map((difficulty) {
        final isCompleted = songProgress.completedDifficulties.contains(
          difficulty,
        );
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isCompleted
                ? _getDifficultyColor(difficulty)
                : Colors.grey.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 10, color: Colors.white)
              : null,
        );
      }).toList(),
    );
  }

  Color _getDifficultyColor(LevelIndex difficulty) {
    switch (difficulty) {
      case LevelIndex.basic:
        return Colors.green;
      case LevelIndex.advanced:
        return Colors.orange;
      case LevelIndex.expert:
        return Colors.red;
      case LevelIndex.master:
        return Colors.purple;
      case LevelIndex.reMaster:
        return Colors.deepPurple;
    }
  }
}
