import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/maimai/viewmodels/kaleidxscope_progress_view_model.dart';
import 'package:rank_hub/models/maimai/kaleidxscope.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/maimai/pages/kaleidxscope_detail_page.dart';

class KaleidxscopeTab extends ConsumerStatefulWidget {
  const KaleidxscopeTab({super.key});

  @override
  ConsumerState<KaleidxscopeTab> createState() => _KaleidxscopeTabState();
}

class _KaleidxscopeTabState extends ConsumerState<KaleidxscopeTab> {
  List<Kaleidxscope>? _kaleidxscopes;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/kaleidxscope.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _kaleidxscopes = jsonList.map((e) => Kaleidxscope.fromJson(e)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('加载失败: $_error'));
    }

    if (_kaleidxscopes == null || _kaleidxscopes!.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _kaleidxscopes!.length,
      itemBuilder: (context, index) {
        final item = _kaleidxscopes![index];
        return _KaleidxscopeCard(item: item);
      },
    );
  }
}

class _KaleidxscopeCard extends ConsumerWidget {
  final Kaleidxscope item;

  const _KaleidxscopeCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // 状态判断
    final daysSinceActive = item.daysSinceActive;
    final isActive = daysSinceActive >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          pushDetailPage(
            context,
            KaleidxscopeDetailPage(item: item),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Stack(
              children: [
                Image.asset(
                  'assets/images/${item.banner}',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Consumer(
                    builder: (context, ref, child) {
                      ref.watch(kaleidxscopeProgressProvider);
                      final viewModel = ref.read(
                        kaleidxscopeProgressProvider.notifier,
                      );
                      final progress = viewModel.getProgress(
                        item.title,
                        item.keyUnlockCondition.songs,
                      );
                      if (progress == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '进度: ${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      if (isActive) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.currentLife} 血',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isActive ? '已开始' : '未开始',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.activeDate,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
