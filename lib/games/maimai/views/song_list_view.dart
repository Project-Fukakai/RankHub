import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/widgets/song_list_item.dart';

class SongListView extends ConsumerWidget {
  const SongListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceState = ref.watch(
      resourceProviderOf<List<MaimaiSong>>(maimaiSongListResourceKey),
    );

    return switch (resourceState) {
      AsyncData<List<MaimaiSong>> data => RefreshIndicator(
        child: ListView.builder(
          itemCount: data.value.length,
          itemBuilder: (context, index) {
            final song = data.value[index];
            return SongListItem(song: song);
          },
        ),
        onRefresh: () async {
          final provider = resourceProviderOf<List<MaimaiSong>>(
            maimaiSongListResourceKey,
          );
          ref.invalidate(provider);
          await ref.read(provider.future);
        },
      ),
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(error: var error, stackTrace: _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              '加载歌曲列表时出错:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(
                  resourceProviderOf<List<MaimaiSong>>(
                    maimaiSongListResourceKey,
                  ),
                );
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    };
  }
}
