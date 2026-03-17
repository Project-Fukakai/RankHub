import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rank_hub/controllers/game_controller.dart';
import 'package:rank_hub/widgets/legacy_game_selector_sheet.dart';

class RankPage extends GetView<GameController> {
  const RankPage({super.key});

  void _showGameSelector() {
    final games = controller.getAvailableGames();
    LegacyGameSelectorSheet.show(
      Get.context!,
      games: games,
      selectedGame: controller.selectedRankGame,
      onGameSelected: controller.selectRankGame,
      title: '选择游戏',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedGame = controller.selectedRankGame;
      final contentViews = selectedGame?.buildRankViews(context) ?? [];

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
          titleSpacing: 24,
          title: const Text('成绩'),
          actions: [
            TextButton.icon(
              onPressed: _showGameSelector,
              icon: Text(
                selectedGame?.name ?? '选择游戏',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              label: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
          centerTitle: false,
        ),
        body: contentViews.isEmpty
            ? _buildEmptyState(context)
            : contentViews.length == 1
            ? _buildSingleView(context, contentViews[0])
            : _buildTabView(context, contentViews),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.leaderboard_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 20),
          Text(
            '暂无内容',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '请先添加账号并选择游戏',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleView(BuildContext context, dynamic contentView) {
    return Scaffold(
      body: contentView.builder(context),
      floatingActionButton: contentView.fabBuilder?.call(context),
    );
  }

  Widget _buildTabView(BuildContext context, List<dynamic> contentViews) {
    return DefaultTabController(
      length: contentViews.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: contentViews
                .map(
                  (view) => Tab(
                    text: view.label as String,
                    icon: view.icon != null
                        ? Icon(view.icon as IconData)
                        : null,
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: contentViews
              .map<Widget>((view) => view.builder(context) as Widget)
              .toList(),
        ),
        floatingActionButton: _buildTabFAB(context, contentViews),
      ),
    );
  }

  Widget? _buildTabFAB(BuildContext context, List<dynamic> contentViews) {
    for (var view in contentViews) {
      final fab = view.fabBuilder?.call(context);
      if (fab != null) return fab as Widget;
    }
    return null;
  }
}
