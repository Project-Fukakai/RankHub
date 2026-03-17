import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:split_button_m3e/split_button_m3e.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/viewmodels/random_song_picker_view_model.dart';
import 'package:rank_hub/games/maimai/states/random_picker_state.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import '../pages/song_detail_page.dart';

/// 随机选曲页面
class RandomSongPickerPage extends ConsumerWidget {
  const RandomSongPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(randomSongPickerViewModelProvider);
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('随机选曲'),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 随机结果显示区域
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.randomSongs.isEmpty
                    ? _buildEmptyState(context)
                    : Column(
                        children: [
                          // 结果标题栏
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '随机结果 (${state.randomSongs.length})',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: viewModel.clearResults,
                                  icon: const Icon(Icons.clear_all, size: 18),
                                  label: const Text('清除全部'),
                                ),
                              ],
                            ),
                          ),
                          // 结果列表
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.randomSongs.length,
                              itemBuilder: (context, index) {
                                final song = state.randomSongs[index];
                                return _buildSongCard(context, ref, song, index + 1);
                              },
                            ),
                          ),
                        ],
                      ),
          ),

          // 快速筛选区域
          _buildQuickFilters(context, ref),

          // 底部操作栏
          _buildBottomBar(context, ref),
        ],
      ),
    );
  }

  /// 构建快速筛选chip区域
  Widget _buildQuickFilters(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(randomSongPickerViewModelProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Builder(builder: (context) {
        final chips = <Widget>[];

        // 难度筛选
        final difficultyLabel = state.selectedDifficulties.isEmpty
            ? '难度'
            : '难度 (${state.selectedDifficulties.length})';
        chips.add(
          FilterChip(
            label: Text(difficultyLabel),
            avatar: const Icon(Icons.star, size: 18),
            selected: state.selectedDifficulties.isNotEmpty,
            onSelected: (_) => _showDifficultyPicker(context, ref),
          ),
        );

        // 分类筛选
        final genreLabel = state.selectedGenres.isEmpty
            ? '分类'
            : '分类 (${state.selectedGenres.length})';
        chips.add(
          FilterChip(
            label: Text(genreLabel),
            avatar: const Icon(Icons.category, size: 18),
            selected: state.selectedGenres.isNotEmpty,
            onSelected: (_) => _showGenrePicker(context, ref),
          ),
        );

        // 版本筛选
        final versionLabel = state.selectedVersionIds.isEmpty
            ? '版本'
            : '版本 (${state.selectedVersionIds.length})';
        chips.add(
          FilterChip(
            label: Text(versionLabel),
            avatar: const Icon(Icons.update, size: 18),
            selected: state.selectedVersionIds.isNotEmpty,
            onSelected: (_) => _showVersionPicker(context, ref),
          ),
        );

        // 定数范围筛选
        final hasLevelRange =
            state.minLevel > 1.0 || state.maxLevel < 15.0;
        final levelLabel = hasLevelRange
            ? '定数 ${state.minLevel.toStringAsFixed(1)}-${state.maxLevel.toStringAsFixed(1)}'
            : '定数';
        chips.add(
          FilterChip(
            label: Text(levelLabel),
            avatar: const Icon(Icons.straighten, size: 18),
            selected: hasLevelRange,
            onSelected: (_) => _showLevelRangePicker(context, ref),
          ),
        );

        // 谱面类型筛选
        final chartTypeLabel = state.chartType == 'all'
            ? '类型'
            : state.chartType == 'standard'
            ? '标准'
            : 'DX';
        chips.add(
          FilterChip(
            label: Text(chartTypeLabel),
            avatar: const Icon(Icons.music_note, size: 18),
            selected: state.chartType != 'all',
            onSelected: (_) => _showChartTypePicker(context, ref),
          ),
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(spacing: 8, children: chips),
        );
      }),
    );
  }

  /// 显示难度选择器
  void _showDifficultyPicker(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '选择难度',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      viewModel.setSelectedDifficulties([]);
                      Navigator.pop(context);
                    },
                    child: const Text('清除'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('完成'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(randomSongPickerViewModelProvider);
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: LevelIndex.values.map((diff) {
                      final isSelected = state.selectedDifficulties.contains(diff);
                      return FilterChip(
                        label: Text(diff.label),
                        selected: isSelected,
                        onSelected: (selected) {
                          final newList = List<LevelIndex>.from(state.selectedDifficulties);
                          if (selected) {
                            newList.add(diff);
                          } else {
                            newList.remove(diff);
                          }
                          viewModel.setSelectedDifficulties(newList);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示分类选择器
  void _showGenrePicker(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '选择分类',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      viewModel.setSelectedGenres([]);
                      Navigator.pop(context);
                    },
                    child: const Text('清除'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('完成'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(randomSongPickerViewModelProvider);
                    return state.genres.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            children: state.genres.map((genre) {
                              final isSelected = state.selectedGenres.contains(genre);
                              return CheckboxListTile(
                                title: Text(genre),
                                value: isSelected,
                                onChanged: (selected) {
                                  final newList = List<String>.from(state.selectedGenres);
                                  if (selected == true) {
                                    newList.add(genre);
                                  } else {
                                    newList.remove(genre);
                                  }
                                  viewModel.setSelectedGenres(newList);
                                },
                              );
                            }).toList(),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示版本选择器
  void _showVersionPicker(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '选择版本',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      viewModel.setSelectedVersionIds([]);
                      Navigator.pop(context);
                    },
                    child: const Text('清除'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('完成'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(randomSongPickerViewModelProvider);
                    return state.versions.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            children: state.versions.map((version) {
                              final isSelected = state.selectedVersionIds.contains(version.version);
                              return CheckboxListTile(
                                title: Text(version.title),
                                value: isSelected,
                                onChanged: (selected) {
                                  final newList = List<int>.from(state.selectedVersionIds);
                                  if (selected == true) {
                                    newList.add(version.version);
                                  } else {
                                    newList.remove(version.version);
                                  }
                                  viewModel.setSelectedVersionIds(newList);
                                },
                              );
                            }).toList(),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示定数范围选择器
  void _showLevelRangePicker(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '定数范围',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      viewModel.setMinLevel(1.0);
                      viewModel.setMaxLevel(15.0);
                      Navigator.pop(context);
                    },
                    child: const Text('重置'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('完成'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(randomSongPickerViewModelProvider);
                  return RangeSlider(
                    values: RangeValues(state.minLevel, state.maxLevel),
                    min: 1.0,
                    max: 15.0,
                    divisions: 140,
                    labels: RangeLabels(
                      state.minLevel.toStringAsFixed(1),
                      state.maxLevel.toStringAsFixed(1),
                    ),
                    onChanged: (values) {
                      viewModel.setMinLevel(values.start);
                      viewModel.setMaxLevel(values.end);
                    },
                  );
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(randomSongPickerViewModelProvider);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.minLevel.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.maxLevel.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示谱面类型选择器
  void _showChartTypePicker(
    BuildContext context,
    WidgetRef ref,
  ) {
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '谱面类型',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(randomSongPickerViewModelProvider);
                  return Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('全部'),
                        value: 'all',
                        groupValue: state.chartType,
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.setChartType(value);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('标准'),
                        value: 'standard',
                        groupValue: state.chartType,
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.setChartType(value);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('DX'),
                        value: 'dx',
                        groupValue: state.chartType,
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.setChartType(value);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.casino,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '点击下方按钮开始随机选曲',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建曲目卡片
  Widget _buildSongCard(BuildContext context, WidgetRef ref, MaimaiSong song, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(randomSongPickerViewModelProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          pushDetailPage(
            context,
            SongDetailPage(song: song),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 曲绘
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://assets2.lxns.net/maimai/jacket/${song.songId}.png',
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
                    child: Icon(
                      Icons.music_note,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 曲目信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _buildDynamicChips(
                        song,
                        state,
                        colorScheme,
                      ),
                    ),
                  ],
                ),
              ),
              // 箭头图标
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  /// 根据筛选条件动态构建信息芯片
  List<Widget> _buildDynamicChips(
    MaimaiSong song,
    RandomPickerState state,
    ColorScheme colorScheme,
  ) {
    final chips = <Widget>[];

    // 如果选择了难度或定数，显示匹配的难度信息
    if (state.selectedDifficulties.isNotEmpty ||
        state.minLevel > 1.0 ||
        state.maxLevel < 15.0) {
      // 获取符合条件的谱面
      final difficulties =
          [...song.difficulties.standard, ...song.difficulties.dx].where((
            diff,
          ) {
            if (state.selectedDifficulties.isNotEmpty &&
                !state.selectedDifficulties.contains(diff.difficulty)) {
              return false;
            }
            if (diff.levelValue < state.minLevel ||
                diff.levelValue > state.maxLevel) {
              return false;
            }
            return true;
          }).toList();

      // 显示前3个符合条件的难度
      for (var i = 0; i < difficulties.length && i < 3; i++) {
        final diff = difficulties[i];
        chips.add(
          _buildInfoChip(
            '${diff.difficulty.label} ${diff.levelValue.toStringAsFixed(1)}',
            Icons.star,
            colorScheme,
          ),
        );
      }
    }

    // 如果选择了分类，显示分类
    if (state.selectedGenres.isNotEmpty) {
      chips.add(_buildInfoChip(song.genre, Icons.category, colorScheme));
    }

    // 如果选择了版本，显示版本（需要从版本列表中查找）
    if (state.selectedVersionIds.isNotEmpty) {
      final version = state.versions.cast<MaimaiVersion?>().firstWhere(
        (v) => v?.version == song.version,
        orElse: () => null,
      );
      if (version != null) {
        chips.add(_buildInfoChip(version.title, Icons.update, colorScheme));
      }
    }

    // 如果没有任何筛选条件，显示默认信息
    if (chips.isEmpty) {
      chips.add(_buildInfoChip(song.genre, Icons.category, colorScheme));
      chips.add(_buildInfoChip('BPM ${song.bpm}', Icons.speed, colorScheme));
    }

    return chips;
  }

  /// 构建信息芯片
  Widget _buildInfoChip(String label, IconData icon, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(randomSongPickerViewModelProvider);
    final viewModel = ref.read(randomSongPickerViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SplitButtonM3E<String>(
          size: SplitButtonM3ESize.lg,
          shape: SplitButtonM3EShape.round,
          emphasis: SplitButtonM3EEmphasis.filled,
          label: '随机 ${state.pickCount} 首',
          leadingIcon: Icons.casino,
          onPressed: viewModel.pickRandomSongs,
          items: const [
            SplitButtonM3EItem<String>(value: '1', child: '1 首'),
            SplitButtonM3EItem<String>(value: '3', child: '3 首'),
            SplitButtonM3EItem<String>(value: '5', child: '5 首'),
            SplitButtonM3EItem<String>(value: '10', child: '10 首'),
          ],
          onSelected: (value) {
            viewModel.setPickCount(int.parse(value));
          },
          leadingTooltip: '随机选曲',
          trailingTooltip: '打开菜单',
        ),
      ),
    );
  }
}
