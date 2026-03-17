import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/maimai_song_view_model.dart';
import 'song_list_item.dart';
import 'dart:ui';

/// 曲目列表视图 - 包含搜索和筛选
class SongListView extends ConsumerStatefulWidget {
  const SongListView({super.key});

  @override
  ConsumerState<SongListView> createState() => _SongListViewState();
}

class _SongListViewState extends ConsumerState<SongListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 监听搜索框变化
    _searchController.addListener(() {
      ref.read(maimaiSongViewModelProvider.notifier).setSearchKeyword(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maimaiSongViewModelProvider);
    final viewModel = ref.read(maimaiSongViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // 曲目列表
        if (state.filteredSongs.isEmpty)
          RefreshIndicator(
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
          )
        else
          RefreshIndicator(
            onRefresh: () async {
              await viewModel.loadSongs(forceRefresh: true);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 160),
              itemCount: state.filteredSongs.length,
              itemBuilder: (context, index) {
                final song = state.filteredSongs[index];
                return SongListItem(song: song);
              },
            ),
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
                  color: colorScheme.surface.withValues(alpha: 0.8),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 搜索框
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '搜索曲名、艺术家、谱师、分类...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 筛选按钮
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // 分类筛选
                            FilterChip(
                              label: Text(
                                state.currentFilter.selectedGenre == null
                                    ? '分类'
                                    : state.currentFilter.selectedGenre!,
                              ),
                              selected: state.currentFilter.selectedGenre != null,
                              onSelected: (selected) {
                                _showGenreFilter();
                              },
                              avatar: const Icon(Icons.category, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // 版本筛选
                            FilterChip(
                              label: Text(
                                state.currentFilter.selectedVersionId == null
                                    ? '版本'
                                    : viewModel.getVersionLabel(
                                        state.currentFilter.selectedVersionId!,
                                      ),
                              ),
                              selected: state.currentFilter.selectedVersionId != null,
                              onSelected: (selected) {
                                _showVersionFilter();
                              },
                              avatar: const Icon(Icons.update, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // 谱面类型筛选
                            FilterChip(
                              label: Text(
                                state.currentFilter.selectedType == null
                                    ? '类型'
                                    : viewModel.getTypeLabel(
                                        state.currentFilter.selectedType!,
                                      ),
                              ),
                              selected: state.currentFilter.selectedType != null,
                              onSelected: (selected) {
                                _showTypeFilter();
                              },
                              avatar: const Icon(Icons.music_note, size: 18),
                            ),
                            const SizedBox(width: 8),
                            // 清除筛选
                            if (state.currentFilter.selectedGenre != null ||
                                state.currentFilter.selectedVersionId != null ||
                                state.currentFilter.selectedType != null)
                              ActionChip(
                                label: const Text('清除筛选'),
                                onPressed: () {
                                  viewModel.clearFilters();
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

  /// 显示分类筛选对话框
  void _showGenreFilter() {
    final state = ref.read(maimaiSongViewModelProvider);
    final viewModel = ref.read(maimaiSongViewModelProvider.notifier);
    final genres = state.getGenreNames();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择分类'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: state.currentFilter.selectedGenre == null,
                onTap: () {
                  viewModel.setGenreFilter(null);
                  Navigator.pop(context);
                },
              ),
              ...genres.map(
                (genre) => ListTile(
                  title: Text(genre),
                  selected: state.currentFilter.selectedGenre == genre,
                  onTap: () {
                    viewModel.setGenreFilter(genre);
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

  /// 显示版本筛选对话框
  void _showVersionFilter() {
    final state = ref.read(maimaiSongViewModelProvider);
    final viewModel = ref.read(maimaiSongViewModelProvider.notifier);
    final versions = state.versions;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择版本'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: state.currentFilter.selectedVersionId == null,
                onTap: () {
                  viewModel.setVersionFilter(null);
                  Navigator.pop(context);
                },
              ),
              ...versions.map(
                (version) => ListTile(
                  title: Text(version.title),
                  selected: state.currentFilter.selectedVersionId == version.versionId,
                  onTap: () {
                    viewModel.setVersionFilter(version.versionId);
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

  /// 显示谱面类型筛选对话框
  void _showTypeFilter() {
    final state = ref.read(maimaiSongViewModelProvider);
    final viewModel = ref.read(maimaiSongViewModelProvider.notifier);
    final types = state.getTypeOptions();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择谱面类型'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('全部'),
                selected: state.currentFilter.selectedType == null,
                onTap: () {
                  viewModel.setTypeFilter(null);
                  Navigator.pop(context);
                },
              ),
              ...types.map(
                (type) => ListTile(
                  title: Text(type['label']!),
                  selected: state.currentFilter.selectedType == type['value'],
                  onTap: () {
                    viewModel.setTypeFilter(type['value']!);
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
}
