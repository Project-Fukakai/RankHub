import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/maimai/maimai_providers.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../widgets/note_table.dart';
import '../widgets/score_history_chart.dart';
import '../widgets/dx_rating_table.dart';
import '../widgets/current_score_card.dart';
import '../widgets/tolerance_calculator.dart';

/// 谱面详情页面
class DifficultyDetailPage extends ConsumerStatefulWidget {
  final dynamic difficulty; // SongDifficulty or SongDifficultyUtage
  final String songName;
  final int songId;

  const DifficultyDetailPage({
    super.key,
    required this.difficulty,
    required this.songName,
    required this.songId,
  });

  @override
  ConsumerState<DifficultyDetailPage> createState() =>
      _DifficultyDetailPageState();
}

class _DifficultyDetailPageState extends ConsumerState<DifficultyDetailPage>
    with SingleTickerProviderStateMixin {
  int _calculateMode = 1; // 0: 绝对值, 1: CRITICAL差值, 2: PERFECT差值
  final ChromeSafariBrowser browser = ChromeSafariBrowser();
  List<Map<String, dynamic>>? _historyData;
  final bool _isLoadingHistory = false;
  String? _historyError;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final difficultyColor = _getDifficultyColor();
    final width = MediaQuery.of(context).size.width;
    final isEmbeddedMode = width >= 1024;

    // 通过 provider 获取成绩
    final currentScore = ref.watch(maimaiScoreByIdProvider(widget.songId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: !isEmbeddedMode,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://assets2.lxns.net/maimai/jacket/${widget.songId}.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 32,
                    height: 32,
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.music_note,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.songName,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${widget.difficulty.difficulty.label} ${widget.difficulty.level}',
                    style: TextStyle(fontSize: 14, color: difficultyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '谱面信息'),
            Tab(text: '谱面评论'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 谱面信息页
          widget.difficulty.notes == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无物量数据',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 基本信息卡片
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '谱面信息',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  '难度',
                                  widget.difficulty.difficulty.label,
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  '定数',
                                  widget.difficulty.levelValue.toStringAsFixed(
                                    1,
                                  ),
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  '谱师',
                                  widget.difficulty.noteDesigner,
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  '类型',
                                  widget.difficulty.type.value == 'dx'
                                      ? 'DX'
                                      : '标准',
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  '总物量',
                                  widget.difficulty.notes!.total.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 搜索谱面确认按钮
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              final keyword =
                                  '${widget.songName} ${widget.difficulty.difficulty.label} 谱面确认';
                              final url =
                                  'bilibili://search?keyword=$keyword'; // 替换为目标应用的 URL Scheme
                              final Uri uri = Uri.parse(url);

                              if (!await launchUrl(uri)) {
                                await browser.open(
                                  url: WebUri(
                                    "https://search.bilibili.com/video?keyword=$keyword",
                                  ),
                                  settings: ChromeSafariBrowserSettings(
                                    presentationStyle:
                                        ModalPresentationStyle.FORM_SHEET,
                                    shareState:
                                        CustomTabsShareState.SHARE_STATE_OFF,
                                    barCollapsingEnabled: true,
                                  ),
                                );
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("在 哔哩哔哩 中搜索谱面确认"),
                                SizedBox(width: 8),
                                Icon(Icons.open_in_new),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 当前成绩卡片
                        if (currentScore != null)
                          CurrentScoreCard(
                            score: currentScore,
                            maxDxScore: widget.difficulty.notes!.total * 3,
                          ),
                        if (currentScore != null) const SizedBox(height: 16),
                        // 历史成绩图表
                        if (_historyData != null ||
                            _isLoadingHistory ||
                            _historyError != null)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '历史成绩',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const Spacer(),
                                      if (_historyData != null)
                                        Text(
                                          '共 ${_historyData!.length} 次游玩',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (_isLoadingHistory)
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else if (_historyError != null)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              size: 48,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '加载失败: $_historyError',
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else if (_historyData != null &&
                                      _historyData!.isNotEmpty)
                                    SizedBox(
                                      height: 300,
                                      child: ScoreHistoryChart(
                                        historyData: _historyData!,
                                      ),
                                    )
                                  else
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32),
                                        child: Text('暂无历史成绩数据'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // 物量详情表（包含计算模式选择）
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '物量详情表',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                // 计算模式选择
                                SegmentedButton<int>(
                                  segments: const [
                                    ButtonSegment(
                                      value: 0,
                                      label: Text('绝对值'),
                                      icon: Icon(Icons.calculate, size: 16),
                                    ),
                                    ButtonSegment(
                                      value: 1,
                                      label: Text('CRITICAL差值'),
                                      icon: Icon(Icons.stars, size: 16),
                                    ),
                                    ButtonSegment(
                                      value: 2,
                                      label: Text('PERFECT差值'),
                                      icon: Icon(Icons.star, size: 16),
                                    ),
                                  ],
                                  selected: {_calculateMode},
                                  onSelectionChanged: (Set<int> newSelection) {
                                    setState(() {
                                      _calculateMode = newSelection.first;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 380,
                                  child: NoteTable(
                                    notes: widget.difficulty.notes!,
                                    calculateMode: _calculateMode,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 容错计算器
                        ToleranceCalculator(notes: widget.difficulty.notes!),
                        const SizedBox(height: 16),
                        // DX Rating 分表
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'DX Rating 分数表',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (currentScore != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${currentScore.achievements.toStringAsFixed(4)}% → ${currentScore.dxRating.toInt()}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                DxRatingTable(
                                  levelValue: widget.difficulty.levelValue,
                                  currentAchievement:
                                      currentScore?.achievements,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          // 谱面评论页
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  '施工中',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '谱面评论功能开发中，敬请期待',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty.difficulty) {
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
      default:
        return Colors.blue;
    }
  }
}
