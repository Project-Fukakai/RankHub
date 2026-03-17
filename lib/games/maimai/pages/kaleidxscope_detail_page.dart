import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:collection/collection.dart';
import 'package:rank_hub/models/maimai/kaleidxscope.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/viewmodels/kaleidxscope_progress_view_model.dart';
import 'package:rank_hub/games/maimai/viewmodels/maimai_song_view_model.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'song_detail_page.dart';

class KaleidxscopeDetailPage extends ConsumerStatefulWidget {
  final Kaleidxscope item;

  const KaleidxscopeDetailPage({super.key, required this.item});

  @override
  ConsumerState<KaleidxscopeDetailPage> createState() =>
      _KaleidxscopeDetailPageState();
}

class _KaleidxscopeDetailPageState extends ConsumerState<KaleidxscopeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, GlobalKey> _songKeys = {};

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

  void _scrollToFirstUncompleted() {
    final viewModel = ref.read(kaleidxscopeProgressProvider.notifier);
    final songIds = widget.item.keyUnlockCondition.songs;

    for (final songId in songIds) {
      if (!viewModel.isCompleted(widget.item.title, songId)) {
        final key = _songKeys[songId];
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure songs are loaded
    final songState = ref.watch(maimaiSongViewModelProvider);
    final progressMap = ref.watch(kaleidxscopeProgressProvider);
    final progressViewModel = ref.read(kaleidxscopeProgressProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final isEmbeddedMode = width >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        automaticallyImplyLeading: !isEmbeddedMode,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '解锁条件'),
            Tab(text: '挑战曲库'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 解锁条件 Tab
          _buildConditionTab(
            context,
            songState.allSongs,
            progressMap,
            progressViewModel,
          ),
          // Track 曲库 Tab
          _buildTrackTab(context, songState.allSongs),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          // 只在第一个 Tab (解锁条件) 且区域已开启时显示 FAB
          if (_tabController.index != 0 || !widget.item.isActive) {
            return const SizedBox.shrink();
          }

          final completedCount = progressViewModel.getCompletedCount(
            widget.item.title,
          );
          final isAllCompleted =
              completedCount == widget.item.keyUnlockCondition.songs.length;

          if (isAllCompleted || widget.item.keyUnlockCondition.songs.isEmpty) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: _scrollToFirstUncompleted,
            icon: const Icon(Icons.gps_fixed),
            label: const Text('当前进度'),
          );
        },
      ),
    );
  }

  Widget _buildConditionTab(
    BuildContext context,
    List<MaimaiSong> songs,
    Map<String, Set<int>> progressMap,
    KaleidxscopeProgressViewModel progressViewModel,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Image.asset(
            'assets/images/${widget.item.banner}',
            width: double.infinity,
            fit: BoxFit.fitWidth,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusPanel(context),
                const SizedBox(height: 24),
                _buildSectionHeader(context, '门扉发现条件'),
                Text(widget.item.doorUnlockCondition),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader(context, '钥匙获取条件'),
                    Builder(
                      builder: (context) {
                        final count = progressViewModel.getCompletedCount(
                          widget.item.title,
                        );
                        // 这里的总数也需要考虑正则匹配到的歌曲
                        final rawSongIds = widget.item.keyUnlockCondition.songs;
                        final baseSongIds =
                            rawSongIds.where((id) => id != -1).toList();
                        int totalCount = baseSongIds.length;

                        if (widget.item.areaRegx != null) {
                          try {
                            final regx = RegExp(widget.item.areaRegx!);
                            final matchedCount =
                                songs.where((s) {
                                  if (baseSongIds.contains(s.songId)) {
                                    return false;
                                  }
                                  return s.map != null &&
                                      regx.hasMatch(s.map!);
                                }).length;
                            totalCount += matchedCount;
                          } catch (e) {
                            debugPrint('Error matching area_regx: $e');
                          }
                        }

                        return Text(
                          widget.item.isActive
                              ? '$count/$totalCount'
                              : '尚未开启',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color:
                                    !widget.item.isActive
                                        ? Colors.grey
                                        : (count == totalCount
                                            ? Colors.green
                                            : Theme.of(
                                              context,
                                            ).colorScheme.secondary),
                                fontWeight: FontWeight.bold,
                              ),
                        );
                      },
                    ),
                  ],
                ),
                Text(widget.item.keyUnlockCondition.description),
                const SizedBox(height: 16),
                _buildKeySongsList(songs, progressMap, progressViewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPanel(BuildContext context) {
    final cd = widget.item.countdown;
    if (cd != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            const Icon(Icons.lock_clock, color: Colors.orange, size: 32),
            const SizedBox(height: 8),
            const Text(
              '区域尚未开启',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            SlideCountdown(
              duration: cd,
              separatorType: SeparatorType.symbol,
              slideDirection: SlideDirection.down,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'monospace',
              ),
              separatorStyle: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
              onDone: () {
                // 倒计时结束时刷新页面
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            Text(
              '开启时间: ${widget.item.activeDate} 07:00',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (widget.item.daysSinceActive < 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '当前血量要求: ${widget.item.currentLife} 血',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.layers,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '当前难度要求: ${widget.item.currentDifficultyRequirement}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (widget.item.nextRelaxationInfo != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.item.nextRelaxationInfo!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildKeySongsList(
    List<MaimaiSong> allSongs,
    Map<String, Set<int>> progressMap,
    KaleidxscopeProgressViewModel progressViewModel,
  ) {
    // 1. 过滤掉 ID 为 -1 的歌曲，并记录是否存在 -1
    final rawSongIds = widget.item.keyUnlockCondition.songs;
    final songIds = rawSongIds.where((id) => id != -1).toList();
    final hasHiddenSongs = rawSongIds.any((id) => id == -1);

    // 2. 处理 area_regx 匹配
    if (widget.item.areaRegx != null) {
      try {
        final regx = RegExp(widget.item.areaRegx!);
        final matchedSongs =
            allSongs
                .where((s) {
                  // 避免重复添加已经在 songIds 里的
                  if (songIds.contains(s.songId)) return false;
                  return s.map != null && regx.hasMatch(s.map!);
                })
                .map((s) => s.songId);
        songIds.addAll(matchedSongs);
      } catch (e) {
        debugPrint('Invalid area_regx: ${widget.item.areaRegx}');
      }
    }

    if (songIds.isEmpty && !hasHiddenSongs) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: songIds.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final songId = songIds[index];
            final song = allSongs.firstWhereOrNull((s) => s.songId == songId);

            // 为每个 item 分配或获取 GlobalKey
            final key = _songKeys.putIfAbsent(songId, () => GlobalKey());

            final isCompleted = progressViewModel.isCompleted(
              widget.item.title,
              songId,
            );

            return Dismissible(
              key: Key('song_${songId}_$isCompleted'),
              direction:
                  !widget.item.isActive
                      ? DismissDirection.none
                      : (isCompleted
                          ? DismissDirection.startToEnd
                          : DismissDirection.endToStart),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.undo, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.check, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                progressViewModel.toggleCompletion(widget.item.title, songId);
                return false;
              },
              child: ListTile(
                key: key,
                onTap:
                    song != null
                        ? () {
                            pushDetailPage(
                              context,
                              SongDetailPage(song: song),
                            );
                          }
                        : null,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child:
                      song != null
                          ? CachedNetworkImage(
                            imageUrl: LxnsApiService.getJacketUrl(song.songId),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.music_note),
                                ),
                          )
                          : Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey[200],
                            child: const Icon(Icons.music_note),
                          ),
                ),
                title: Text(
                  song?.title ?? 'ID: $songId',
                  style: TextStyle(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : null,
                  ),
                ),
                subtitle: song != null ? Text(song.artist) : null,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    isCompleted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : Icon(
                          Icons.circle_outlined,
                          color:
                              widget.item.isActive
                                  ? Colors.grey
                                  : Colors.grey.withValues(alpha: 0.3),
                        ),
                    const SizedBox(height: 2),
                    Text(
                      !widget.item.isActive
                          ? '区域开启后解锁'
                          : (isCompleted ? '右滑撤销' : '左滑完成'),
                      style: TextStyle(
                        fontSize: 9,
                        color:
                            widget.item.isActive
                                ? Colors.grey[400]
                                : Colors.grey[400]?.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (hasHiddenSongs)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '部分曲目尚未更新，待门扉解禁后可显示完整列表',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrackTab(BuildContext context, List<MaimaiSong> songs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusPanel(context),
          const SizedBox(height: 24),
          _buildTrackSection(
            context,
            'Track 1',
            widget.item.track1,
            songs,
          ),
          const SizedBox(height: 24),
          _buildTrackSection(
            context,
            'Track 2',
            widget.item.track2,
            songs,
          ),
          const SizedBox(height: 24),
          _buildTrackSection(
            context,
            'Track 3',
            widget.item.track3,
            songs,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackSection(
    BuildContext context,
    String title,
    KaleidxscopeTrack track,
    List<MaimaiSong> songs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, title),
        if (track.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(track.description),
          ),
        _SongHorizontalList(
          songIds: track.songs,
          allSongs: songs,
          areaRegx: widget.item.areaRegx,
        ),
      ],
    );
  }
}

class _SongHorizontalList extends ConsumerWidget {
  final List<int> songIds;
  final List<MaimaiSong> allSongs;
  final String? areaRegx;

  const _SongHorizontalList({
    required this.songIds,
    required this.allSongs,
    this.areaRegx,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 处理基础列表
    final currentSongIds = songIds.where((id) => id != -1).toList();

    // 2. 处理正则匹配
    if (areaRegx != null) {
      try {
        final regx = RegExp(areaRegx!);
        final matchedIds =
            allSongs
                .where((s) {
                  if (currentSongIds.contains(s.songId)) return false;
                  return s.map != null && regx.hasMatch(s.map!);
                })
                .map((s) => s.songId);
        currentSongIds.addAll(matchedIds);
      } catch (e) {
        debugPrint('Invalid area_regx in Track: $areaRegx');
      }
    }

    if (currentSongIds.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: currentSongIds.length,
        itemBuilder: (context, index) {
          final songId = currentSongIds[index];
          final song = allSongs.firstWhereOrNull((s) => s.songId == songId);

          return GestureDetector(
            onTap:
                song != null
                    ? () {
                        pushDetailPage(
                          context,
                          SongDetailPage(song: song),
                        );
                      }
                    : null,
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        song != null
                            ? CachedNetworkImage(
                              imageUrl: LxnsApiService.getJacketUrl(
                                song.songId,
                              ),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorWidget:
                                  (context, url, error) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 30,
                                    ),
                                  ),
                            )
                            : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.music_note, size: 30),
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song?.title ?? 'ID: $songId',
                    style: const TextStyle(fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
