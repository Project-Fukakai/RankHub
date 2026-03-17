import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/viewmodels/game_selection_view_model.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/widgets/game_selector_sheet.dart';

class WikiPageV2 extends ConsumerWidget {
  const WikiPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameSelectionViewModelProvider);
    final selectedGame = gameState.selectedGame;

    if (gameState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final libraryPages = selectedGame?.descriptor.libraryPages ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        titleSpacing: 24,
        title: const Text('资料库'),
        actions: [
          TextButton.icon(
            onPressed: () => _showGameSelector(context, ref),
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
      body: libraryPages.isEmpty
          ? _buildEmptyState(context)
          : libraryPages.length == 1
              ? _buildSingleView(context, libraryPages[0])
              : _buildTabView(context, libraryPages),
    );
  }

  void _showGameSelector(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(gameSelectionViewModelProvider);
    GameSelectorSheet.show(
      context,
      games: gameState.availableGames,
      selectedGame: gameState.selectedGame,
      onGameSelected: (game) {
        ref.read(gameSelectionViewModelProvider.notifier).selectGame(game);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
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
            '请选择游戏',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleView(BuildContext context, PageDescriptor page) {
    return Scaffold(
      body: page.builder(context),
      floatingActionButton: page.fabBuilder?.call(context),
    );
  }

  Widget _buildTabView(BuildContext context, List<PageDescriptor> pages) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: pages
                .map(
                  (page) => Tab(
                    text: page.title,
                    icon: Icon(page.icon),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: pages.map((page) => page.builder(context)).toList(),
        ),
        floatingActionButton: _buildTabFAB(context, pages),
      ),
    );
  }

  Widget? _buildTabFAB(BuildContext context, List<PageDescriptor> pages) {
    for (var page in pages) {
      final fab = page.fabBuilder?.call(context);
      if (fab != null) return fab;
    }
    return null;
  }
}
