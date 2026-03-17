import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/maimai_score_view_model.dart';
import 'compact_score_card.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/fc_type.dart';
import 'package:rank_hub/games/maimai/models/enums/fs_type.dart';
import 'package:rank_hub/games/maimai/models/enums/rate_type.dart';
import 'dart:ui';

/// 成绩列表视图 - 包含排序和筛选
class ScoreListView extends ConsumerStatefulWidget {
  const ScoreListView({super.key});

  @override
  ConsumerState<ScoreListView> createState() => _ScoreListViewState();
}

class _ScoreListViewState extends ConsumerState<ScoreListView> {
  // 筛选条件
  LevelIndex? _selectedLevel;
  FCType? _selectedFc;
  FSType? _selectedFs;
  RateType? _selectedRate;
  String _selectedType = ''; // standard, dx
  double? _minAchievement;

  // 排序方式
  String _sortBy = 'dxRating'; // dxRating, achievements, level

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maimaiScoreViewModelProvider);
    final viewModel = ref.read(maimaiScoreViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // 成绩列表
        if (state.allScores.isEmpty)
          RefreshIndicator(
            onRefresh: () async {
              await viewModel.loadScores(forceRefresh: true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.leaderboard,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无成绩数据',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '请先同步数据',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          Builder(
            builder: (context) {
              // 应用筛选和排序
              var scores = state.allScores.toList();

          // 筛选
          if (_selectedLevel != null) {
            scores = scores
                .where((score) => score.levelIndex == _selectedLevel)
                .toList();
          }
          if (_selectedFc != null) {
            scores = scores.where((score) => score.fc == _selectedFc).toList();
          }
          if (_selectedFs != null) {
            scores = scores.where((score) => score.fs == _selectedFs).toList();
          }
          if (_selectedRate != null) {
            scores = scores
                .where((score) => score.rate == _selectedRate)
                .toList();
          }
          if (_selectedType.isNotEmpty) {
            scores = scores
                .where((score) => score.type.value == _selectedType)
                .toList();
          }
          if (_minAchievement != null) {
            scores = scores
                .where((score) => score.achievements >= _minAchievement!)
                .toList();
          }

          // 排序
          scores.sort((a, b) {
            switch (_sortBy) {
              case 'achievements':
                return b.achievements.compareTo(a.achievements);
              case 'level':
                // 解析定数
                final aLevelStr = a.level.replaceAll('+', '');
                final bLevelStr = b.level.replaceAll('+', '');
                final aLevelValue = double.tryParse(aLevelStr) ?? 0;
                final bLevelValue = double.tryParse(bLevelStr) ?? 0;
                final aActual = a.level.contains('+')
                    ? aLevelValue + 0.7
                    : aLevelValue;
                final bActual = b.level.contains('+')
                    ? bLevelValue + 0.7
                    : bLevelValue;
                return bActual.compareTo(aActual);
              case 'dxRating':
              default:
                return b.dxRating.compareTo(a.dxRating);
            }
          });

          if (scores.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await viewModel.loadScores(forceRefresh: true);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list_off,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '没有符合条件的成绩',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await viewModel.loadScores(forceRefresh: true);
            },
            child: ListView.separated(
              padding: const EdgeInsets.only(
                bottom: 200,
                left: 8,
                right: 8,
                top: 8,
              ),
              itemCount: scores.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final score = scores[index];
                return CompactScoreCard(score);
              },
            ),
          );
        }),
        // 筛选和排序栏 - 浮在底部
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.8),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 排序选择
                      Row(
                        children: [
                          const Icon(Icons.sort, size: 20),
                          const SizedBox(width: 8),
                          const Text('排序:'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(
                                  value: 'dxRating',
                                  label: Text('Rating'),
                                  icon: Icon(Icons.star, size: 16),
                                ),
                                ButtonSegment(
                                  value: 'achievements',
                                  label: Text('达成率'),
                                  icon: Icon(Icons.percent, size: 16),
                                ),
                                ButtonSegment(
                                  value: 'level',
                                  label: Text('定数'),
                                  icon: Icon(Icons.trending_up, size: 16),
                                ),
                              ],
                              selected: {_sortBy},
                              onSelectionChanged: (Set<String> newSelection) {
                                setState(() {
                                  _sortBy = newSelection.first;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 筛选按钮
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // 难度筛选
                            FilterChip(
                              label: Text(
                                _selectedLevel == null
                                    ? '难度'
                                    : _getLevelName(_selectedLevel!),
                              ),
                              selected: _selectedLevel != null,
                              onSelected: (selected) {
                                _showLevelFilter();
                              },
                              avatar: const Icon(Icons.show_chart, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // FC 筛选
                            FilterChip(
                              label: Text(
                                _selectedFc == null ? 'FC' : _selectedFc!.name,
                              ),
                              selected: _selectedFc != null,
                              onSelected: (selected) {
                                _showFcFilter();
                              },
                              avatar: const Icon(Icons.album, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // FS 筛选
                            FilterChip(
                              label: Text(
                                _selectedFs == null ? 'FS' : _selectedFs!.name,
                              ),
                              selected: _selectedFs != null,
                              onSelected: (selected) {
                                _showFsFilter();
                              },
                              avatar: const Icon(Icons.sync, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // 评级筛选
                            FilterChip(
                              label: Text(
                                _selectedRate == null
                                    ? '评级'
                                    : _selectedRate!.name,
                              ),
                              selected: _selectedRate != null,
                              onSelected: (selected) {
                                _showRateFilter();
                              },
                              avatar: const Icon(Icons.grade, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // 谱面类型筛选
                            FilterChip(
                              label: Text(
                                _selectedType.isEmpty
                                    ? '类型'
                                    : _selectedType == 'standard'
                                    ? '标准'
                                    : 'DX',
                              ),
                              selected: _selectedType.isNotEmpty,
                              onSelected: (selected) {
                                _showTypeFilter();
                              },
                              avatar: const Icon(Icons.music_note, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // 清除筛选
                            if (_hasFilters())
                              ActionChip(
                                label: const Text('清除筛选'),
                                onPressed: () {
                                  setState(() {
                                    _selectedLevel = null;
                                    _selectedFc = null;
                                    _selectedFs = null;
                                    _selectedRate = null;
                                    _selectedType = '';
                                    _minAchievement = null;
                                  });
                                },
                                avatar: const Icon(Icons.clear, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _hasFilters() {
    return _selectedLevel != null ||
        _selectedFc != null ||
        _selectedFs != null ||
        _selectedRate != null ||
        _selectedType.isNotEmpty ||
        _minAchievement != null;
  }

  String _getLevelName(LevelIndex level) {
    switch (level) {
      case LevelIndex.basic:
        return 'BASIC';
      case LevelIndex.advanced:
        return 'ADVANCED';
      case LevelIndex.expert:
        return 'EXPERT';
      case LevelIndex.master:
        return 'MASTER';
      case LevelIndex.reMaster:
        return 'Re:MASTER';
    }
  }

  void _showLevelFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择难度'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: _selectedLevel == null,
                onTap: () {
                  setState(() {
                    _selectedLevel = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ...LevelIndex.values.map(
                (level) => ListTile(
                  title: Text(_getLevelName(level)),
                  selected: _selectedLevel == level,
                  onTap: () {
                    setState(() {
                      _selectedLevel = level;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFcFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择 FC 类型'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: _selectedFc == null,
                onTap: () {
                  setState(() {
                    _selectedFc = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ...FCType.values.map(
                (fc) => ListTile(
                  title: Text(fc.name.toUpperCase()),
                  selected: _selectedFc == fc,
                  onTap: () {
                    setState(() {
                      _selectedFc = fc;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFsFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择 FS 类型'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: _selectedFs == null,
                onTap: () {
                  setState(() {
                    _selectedFs = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ...FSType.values.map(
                (fs) => ListTile(
                  title: Text(fs.name.toUpperCase()),
                  selected: _selectedFs == fs,
                  onTap: () {
                    setState(() {
                      _selectedFs = fs;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRateFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择评级'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: _selectedRate == null,
                onTap: () {
                  setState(() {
                    _selectedRate = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ...RateType.values.map(
                (rate) => ListTile(
                  title: Text(rate.name.toUpperCase()),
                  selected: _selectedRate == rate,
                  onTap: () {
                    setState(() {
                      _selectedRate = rate;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTypeFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择谱面类型'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('全部'),
              selected: _selectedType.isEmpty,
              onTap: () {
                setState(() {
                  _selectedType = '';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('标准谱面'),
              selected: _selectedType == 'standard',
              onTap: () {
                setState(() {
                  _selectedType = 'standard';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('DX 谱面'),
              selected: _selectedType == 'dx',
              onTap: () {
                setState(() {
                  _selectedType = 'dx';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
