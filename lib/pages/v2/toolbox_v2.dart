import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/viewmodels/game_selection_view_model.dart';
import 'package:rank_hub/core/page_descriptor.dart';

class ToolboxPageV2 extends ConsumerWidget {
  const ToolboxPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameSelectionViewModelProvider);
    final selectedGame = gameState.selectedGame;

    if (gameState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final toolboxPages = selectedGame?.descriptor.toolboxPages ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 24,
        title: const Text('工具箱'),
        centerTitle: false,
      ),
      body: toolboxPages.isEmpty
          ? _buildEmptyState(context)
          : toolboxPages.length == 1
              ? _buildSingleView(context, toolboxPages[0])
              : _buildTabView(context, toolboxPages),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 20),
          Text(
            '暂无工具',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
      ),
    );
  }
}
