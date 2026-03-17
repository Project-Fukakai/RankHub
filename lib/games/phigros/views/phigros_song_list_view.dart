import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/phigros/viewmodels/phigros_view_model.dart';
import 'package:rank_hub/games/phigros/widgets/phigros_song_list_item.dart';

/// Phigros 曲目列表视图 - 包含搜索和难度筛选
class PhigrosSongListView extends ConsumerStatefulWidget {
  const PhigrosSongListView({super.key});

  @override
  ConsumerState<PhigrosSongListView> createState() =>
      _PhigrosSongListViewState();
}

class _PhigrosSongListViewState extends ConsumerState<PhigrosSongListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(phigrosViewModelProvider.notifier).loadSongs(),
    );

    _searchController.addListener(() {
      ref
          .read(phigrosViewModelProvider.notifier)
          .setSearchKeyword(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phigrosViewModelProvider);
    final viewModel = ref.read(phigrosViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final chapterOptions = viewModel.getChapterOptions();
    final selectedChapter = state.selectedChapter;

    return Stack(
      children: [
        if (state.isLoadingSongs)
          const Center(child: CircularProgressIndicator())
        else
          Builder(
            builder: (context) {
              if (state.filteredSongs.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await viewModel.loadSongs(forceRefresh: true);
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
                              Icons.search_off,
                              size: 64,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '未找到匹配的曲目',
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
                  await viewModel.loadSongs(forceRefresh: true);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 200),
                  itemCount: state.filteredSongs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _ChapterFilterChips(
                        chapters: chapterOptions,
                        selected: selectedChapter,
                        onSelect: (value) {
                          viewModel.setChapterFilter(value);
                        },
                      );
                    }
                    final song = state.filteredSongs[index - 1];
                    return PhigrosSongListItem(song: song);
                  },
                ),
              );
            },
          ),

        // 搜索栏 - 浮在底部
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
                  color: colorScheme.surface.withOpacity(0.8),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '搜索曲目、曲师...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: state.searchKeyword.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
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
}

class _ChapterFilterChips extends StatelessWidget {
  const _ChapterFilterChips({
    required this.chapters,
    required this.selected,
    required this.onSelect,
  });

  final List<String> chapters;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chips = <Widget>[
      ChoiceChip(
        label: const Text('All'),
        selected: selected == PhigrosViewModel.allChaptersKey,
        onSelected: (_) => onSelect(PhigrosViewModel.allChaptersKey),
      ),
    ];

    chips.addAll(
      chapters.map(
        (chapter) => ChoiceChip(
          label: Text(chapter),
          selected: selected == chapter,
          onSelected: (isSelected) {
            if (isSelected) {
              onSelect(chapter);
            } else {
              onSelect(null);
            }
          },
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      color: colorScheme.surface.withOpacity(0.6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips
              .map(
                (chip) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: chip,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
