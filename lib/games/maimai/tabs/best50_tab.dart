import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_best50_data.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/widgets/compact_score_card.dart';

/// Best 50 成绩 Tab
class Best50Tab extends ConsumerWidget {
  const Best50Tab({super.key});

  /// 根据 Rating 获取渐变效果
  ShaderMask getShaderMaskByRating(int rating, Widget child) {
    LinearGradient gradient;

    if (rating < 0) {
      gradient = const LinearGradient(colors: [Colors.grey, Colors.grey]);
    } else if (rating <= 999) {
      gradient = const LinearGradient(colors: [Colors.white, Colors.white]);
    } else if (rating <= 1999) {
      gradient = const LinearGradient(colors: [Colors.blue, Colors.blueAccent]);
    } else if (rating <= 3999) {
      gradient = const LinearGradient(
        colors: [Colors.green, Colors.lightGreen],
      );
    } else if (rating <= 6999) {
      gradient = const LinearGradient(colors: [Colors.yellow, Colors.orange]);
    } else if (rating <= 9999) {
      gradient = const LinearGradient(colors: [Colors.red, Colors.redAccent]);
    } else if (rating <= 11999) {
      gradient = const LinearGradient(
        colors: [Colors.purple, Colors.deepPurple],
      );
    } else if (rating <= 12999) {
      gradient = const LinearGradient(
        colors: [Color(0xFFCD7F32), Color(0xFFB87333)],
      ); // 铜色
    } else if (rating <= 13999) {
      gradient = const LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
      ); // 银色
    } else if (rating <= 14499) {
      gradient = const LinearGradient(
        colors: [Colors.amber, Colors.orangeAccent],
      ); // 金色
    } else if (rating <= 14999) {
      gradient = const LinearGradient(
        colors: [
          Color.fromARGB(255, 252, 208, 122),
          Color.fromARGB(255, 252, 255, 160),
        ],
      ); // 白金色
    } else {
      gradient = const LinearGradient(
        colors: [
          Color.fromARGB(255, 47, 214, 184),
          Color.fromARGB(255, 56, 91, 187),
          Color.fromARGB(255, 180, 67, 188),
        ],
      ); // 彩虹色
    }

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }

  /// 格式化 Rating 为五位数，不足的用灰色 0 补足
  Widget _buildRatingText(
    BuildContext context,
    int rating, {
    bool useGradient = false,
    TextStyle? baseStyle,
  }) {
    final ratingStr = rating.toString();
    final paddingCount = 5 - ratingStr.length;

    final textStyle =
        baseStyle ??
        Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

    if (paddingCount <= 0) {
      final textWidget = Text(ratingStr, style: textStyle);
      return useGradient
          ? getShaderMaskByRating(rating, textWidget)
          : textWidget;
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '0' * paddingCount,
          style: textStyle?.copyWith(color: Colors.grey),
        ),
        Text(ratingStr, style: textStyle),
      ],
    );

    return useGradient ? getShaderMaskByRating(rating, content) : content;
  }

  /// 计算评分统计
  Map<String, double> _calculateStats(List<MaimaiScore> scores) {
    if (scores.isEmpty) {
      return {'min': 0, 'avg': 0, 'max': 0};
    }

    final ratings = scores.map((s) => s.dxRating.toDouble()).toList();
    final min = ratings.reduce((a, b) => a < b ? a : b);
    final max = ratings.reduce((a, b) => a > b ? a : b);
    final avg = ratings.reduce((a, b) => a + b) / ratings.length;

    return {'min': min, 'avg': avg, 'max': max};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final resourceState = ref.watch(
      resourceProviderOf<MaimaiBest50Data>(maimaiBest50ResourceKey),
    );

    return switch (resourceState) {
      AsyncLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              '正在加载 Best 50...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      AsyncError(error: var error, stackTrace: _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                style: TextStyle(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  await ref.read(
                    refreshResourceProviderOf<MaimaiBest50Data>(
                      maimaiBest50ResourceKey,
                    ).future,
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      AsyncData(value: final data) => RefreshIndicator(
        onRefresh: () async {
          await ref.read(
            refreshResourceProviderOf<MaimaiBest50Data>(
              maimaiBest50ResourceKey,
            ).future,
          );
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DX Rating',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        _buildRatingText(
                          context,
                          data.totalRating,
                          useGradient: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'DX: ${data.dxTotal}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'SD: ${data.standardTotal}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatsCard(context, data),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildScoreSection(
              context,
              title: 'DX Best 15',
              scores: data.dxScores,
            ),
            _buildScoreSection(
              context,
              title: 'SD Best 35',
              scores: data.standardScores,
            ),
          ],
        ),
      ),
    };
  }

  Widget _buildStatsCard(BuildContext context, MaimaiBest50Data data) {
    final dxStats = _calculateStats(data.dxScores);
    final sdStats = _calculateStats(data.standardScores);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('评分统计', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildStatsRow('DX', dxStats),
            const SizedBox(height: 4),
            _buildStatsRow('SD', sdStats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(String label, Map<String, double> stats) {
    return Row(
      children: [
        SizedBox(width: 32, child: Text(label)),
        Expanded(
          child: Text(
            'Min ${stats['min']!.toStringAsFixed(0)} · '
            'Avg ${stats['avg']!.toStringAsFixed(0)} · '
            'Max ${stats['max']!.toStringAsFixed(0)}',
          ),
        ),
      ],
    );
  }

  SliverList _buildScoreSection(
    BuildContext context, {
    required String title,
    required List<MaimaiScore> scores,
  }) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...scores.map((score) => CompactScoreCard(score)),
      ]),
    );
  }
}
