import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/models/phigros/chart.dart';
import 'package:rank_hub/models/phigros/chart_visualization.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/song.dart';
import 'package:rank_hub/games/phigros/pages/chart_preview_page.dart';
import 'package:rank_hub/games/phigros/viewmodels/phigros_view_model.dart';
import 'package:rank_hub/games/phigros/services/phigros_resource_api_service.dart';

/// Phigros 乐曲详情页面
class PhigrosSongDetailPage extends ConsumerStatefulWidget {
  final PhigrosSong song;

  const PhigrosSongDetailPage({super.key, required this.song});

  @override
  ConsumerState<PhigrosSongDetailPage> createState() =>
      _PhigrosSongDetailPageState();
}

class _PhigrosSongDetailPageState extends ConsumerState<PhigrosSongDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  double _titleOpacity = 0.0;

  // 可用的难度列表
  List<String> availableDifficulties = [];
  Map<String, PhigrosChart> charts = {};
  Map<String, bool> isLoading = {};

  @override
  void initState() {
    super.initState();
    _initializeDifficulties();
    _tabController = TabController(
      length: availableDifficulties.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (!context.mounted) return;
      setState(() {
        _titleOpacity = ((_scrollController.offset - 178) / 72).clamp(0.0, 1.0);
      });
    });

    // 预加载第一个难度的谱面
    if (availableDifficulties.isNotEmpty) {
      _loadChart(availableDifficulties[0]);
    }
  }

  void _initializeDifficulties() {
    if (widget.song.difficultyEZ != null) availableDifficulties.add('EZ');
    if (widget.song.difficultyHD != null) availableDifficulties.add('HD');
    if (widget.song.difficultyIN != null) availableDifficulties.add('IN');
    if (widget.song.difficultyAT != null) availableDifficulties.add('AT');
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final difficulty = availableDifficulties[_tabController.index];
      if (!charts.containsKey(difficulty)) {
        _loadChart(difficulty);
      }
    }
  }

  Future<void> _loadChart(String difficulty) async {
    if (isLoading[difficulty] == true) return;

    setState(() {
      isLoading[difficulty] = true;
    });

    try {
      final chart = await PhigrosResourceApiService.instance.fetchChart(
        widget.song.songId,
        difficulty,
      );
      if (mounted) {
        setState(() {
          charts[difficulty] = chart;
          isLoading[difficulty] = false;
        });
      }
    } catch (e) {
      print('❌ 加载谱面失败: ${widget.song.songId} - $difficulty, 错误: $e');
      if (mounted) {
        setState(() {
          isLoading[difficulty] = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isEmbeddedMode = width >= 1024;

    return Scaffold(
      extendBodyBehindAppBar: !isEmbeddedMode,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // AppBar
            SliverAppBar(
              primary: true,
              titleSpacing: 0,
              stretch: true,
              forceElevated: true,
              centerTitle: false,
              automaticallyImplyLeading: !isEmbeddedMode,
              backgroundColor: colorScheme.surface.withOpacity(0.95),
              surfaceTintColor: Colors.transparent,
              title: Opacity(
                opacity: _titleOpacity,
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  isThreeLine: false,
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: widget.song.illustrationLowResUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 48,
                        height: 48,
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 48,
                        height: 48,
                        color: colorScheme.surfaceContainerHighest,
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.song.name,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    widget.song.composer,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.blurBackground],
                background: _buildExtendedContent(),
              ),
            ),
            // Tab Bar
            if (availableDifficulties.isNotEmpty)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: availableDifficulties.length > 3,
                    tabs: availableDifficulties.map((diff) {
                      return Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(diff),
                            const SizedBox(width: 4),
                            Text(
                              _getDifficultyValue(diff),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getDifficultyColor(diff),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ];
        },
        body: availableDifficulties.isEmpty
            ? const Center(child: Text('暂无谱面数据'))
            : TabBarView(
                controller: _tabController,
                children: availableDifficulties.map((diff) {
                  return _buildDifficultyContent(diff);
                }).toList(),
              ),
      ),
    );
  }

  /// 构建扩展内容
  Widget _buildExtendedContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 背景曲绘
        CachedNetworkImage(
          imageUrl: _getIllustrationUrl(),
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.deepPurple.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(
              child: Icon(Icons.music_note, size: 64, color: Colors.white30),
            ),
          ),
        ),
        // 渐变遮罩
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        // 内容
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 标题
              Text(
                widget.song.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // 作曲家
              Text(
                widget.song.composer,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // 插画师
              if (widget.song.illustrator != null)
                Text(
                  'Illustration: ${widget.song.illustrator}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if ((widget.song.bpm ?? '').isNotEmpty)
                    _InfoChip(label: 'BPM', value: widget.song.bpm!),
                  if ((widget.song.length ?? '').isNotEmpty)
                    _InfoChip(label: '时长', value: widget.song.length!),
                  if ((widget.song.chapter ?? '').isNotEmpty &&
                      widget.song.chapter != '--')
                    _InfoChip(label: '章节', value: widget.song.chapter!),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建难度内容
  Widget _buildDifficultyContent(String difficulty) {
    final chart = charts[difficulty];
    final loading = isLoading[difficulty] == true;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chart == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('加载谱面失败'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadChart(difficulty),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 成绩卡片
          _buildRecordCard(
            difficulty,
            ref.watch(phigrosViewModelProvider).records,
          ),
          const SizedBox(height: 16),
          // 谱面信息卡片
          _buildChartInfoCard(difficulty, chart),
          const SizedBox(height: 16),
          // 物量统计
          _buildNoteStatsCard(chart),
          const SizedBox(height: 16),
          // Note 时间分布可视化
          _buildTimeDistributionCard(chart),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 构建成绩卡片
  Widget _buildRecordCard(String difficulty, List<PhigrosGameRecord> records) {
    try {
      PhigrosGameRecord? record;
      for (final item in records) {
        if (item.songId == widget.song.songId && item.level == difficulty) {
          record = item;
          break;
        }
      }

      if (record == null) {
        return const SizedBox.shrink();
      }

      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 难度颜色指示器
                  Container(
                    width: 4,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty),
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
                          '我的成绩',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildRecordDifficultyRksChip(
                              difficulty,
                              record.constant,
                              record.rks,
                              _getDifficultyColor(difficulty),
                            ),
                            if (record.fc)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.amber.withOpacity(0.3),
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
                            _buildRecordRatingChip(record),
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
                        '${record.acc.toStringAsFixed(2)}%',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.score.toString(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  /// 构建成绩难度RKS芯片
  Widget _buildRecordDifficultyRksChip(
    String level,
    double constant,
    double rks,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
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
              color: color.withOpacity(0.8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.arrow_forward,
              size: 10,
              color: color.withOpacity(0.6),
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

  /// 构建成绩评级芯片
  Widget _buildRecordRatingChip(PhigrosGameRecord record) {
    final color = _getRecordRatingColor(record.rating, record.isBlueV);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        record.rating,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  /// 获取成绩评级颜色
  Color _getRecordRatingColor(String rating, bool isBlueV) {
    if (rating == 'ϕ') return Colors.amber;
    if (rating == 'V') {
      return isBlueV ? Colors.blue : Colors.grey.shade300;
    }
    if (rating == 'S') return Colors.purple;
    if (rating == 'A') return Colors.blue;
    if (rating == 'B') return Colors.green;
    if (rating == 'C') return Colors.orange;
    if (rating == 'F') return Colors.red;
    return Colors.grey;
  }

  /// 构建谱面信息卡片
  Widget _buildChartInfoCard(String difficulty, PhigrosChart chart) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(difficulty).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getDifficultyColor(difficulty)),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getDifficultyColor(difficulty),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getDifficultyValue(difficulty),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(difficulty),
                  ),
                ),
                const Spacer(),
                Text(
                  '${chart.totalNotes} Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (_getChartDesigner(difficulty) != null &&
                _getChartDesigner(difficulty)!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Center(
                child: _buildInfoItem('谱师', _getChartDesigner(difficulty)!),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Material(
                          child: PhigrosChartPreviewPage(
                            song: widget.song,
                            chart: chart,
                            chartComposer: _getChartDesigner(difficulty) ?? "",
                          ),
                        ),
                      ),
                    );
                  },
                  label: Text("铺面预览（实验性）"),
                  icon: Icon(Icons.play_arrow_outlined),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建物量统计卡片
  Widget _buildNoteStatsCard(PhigrosChart chart) {
    final stats = chart.noteTypeStats;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '物量统计',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildNoteTypeRow(
              'Tap',
              stats[NoteType.tap] ?? 0,
              chart.totalNotes,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildNoteTypeRow(
              'Drag',
              stats[NoteType.drag] ?? 0,
              chart.totalNotes,
              Colors.amber,
            ),
            const SizedBox(height: 12),
            _buildNoteTypeRow(
              'Hold',
              stats[NoteType.hold] ?? 0,
              chart.totalNotes,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildNoteTypeRow(
              'Flick',
              stats[NoteType.flick] ?? 0,
              chart.totalNotes,
              Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建 Note 类型统计行
  Widget _buildNoteTypeRow(String label, int count, int total, Color color) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  /// 构建时间分布可视化卡片
  Widget _buildTimeDistributionCard(PhigrosChart chart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Note 时间分布',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            PhigrosChartVisualization(
              chart: chart,
              height: 250,
              showLegend: true,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// 获取难度定数显示文本
  String _getDifficultyValue(String difficulty) {
    switch (difficulty) {
      case 'EZ':
        return widget.song.difficultyEZ?.toStringAsFixed(1) ?? '-';
      case 'HD':
        return widget.song.difficultyHD?.toStringAsFixed(1) ?? '-';
      case 'IN':
        return widget.song.difficultyIN?.toStringAsFixed(1) ?? '-';
      case 'AT':
        return widget.song.difficultyAT?.toStringAsFixed(1) ?? '-';
      default:
        return '-';
    }
  }

  /// 获取难度颜色
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'EZ':
        return Colors.green;
      case 'HD':
        return Colors.blue;
      case 'IN':
        return Colors.red;
      case 'AT':
        return Theme.of(context).colorScheme.onSurface;
      default:
        return Colors.grey;
    }
  }

  /// 获取谱师名称
  String? _getChartDesigner(String difficulty) {
    switch (difficulty) {
      case 'EZ':
        return widget.song.chartDesignerEZ;
      case 'HD':
        return widget.song.chartDesignerHD;
      case 'IN':
        return widget.song.chartDesignerIN;
      case 'AT':
        return widget.song.chartDesignerAT;
      default:
        return null;
    }
  }

  /// 获取曲绘 URL
  String _getIllustrationUrl() {
    return widget.song.illustrationUrl;
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Tab Bar 的 SliverPersistentHeaderDelegate
class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
          child: _tabBar,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) {
    return false;
  }
}
