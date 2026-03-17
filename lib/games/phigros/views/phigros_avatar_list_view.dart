import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/games/phigros/pages/phigros_avatar_detail_page.dart';
import 'package:rank_hub/games/phigros/phigros_resources.dart';
import 'package:rank_hub/models/phigros/avatar.dart';

class PhigrosAvatarListView extends ConsumerWidget {
  const PhigrosAvatarListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarsAsync = ref.watch(
      resourceProviderOf<List<PhigrosAvatar>>(phigrosAvatarListResourceKey),
    );
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> refresh() async {
      await ref.read(
        refreshResourceProviderOf<List<PhigrosAvatar>>(
          phigrosAvatarListResourceKey,
        ).future,
      );
    }

    return avatarsAsync.when(
      data: (avatars) {
        if (avatars.isEmpty) {
          return RefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.face_outlined,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无头像数据',
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
          onRefresh: refresh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 1200
                  ? 6
                  : width >= 900
                  ? 5
                  : width >= 600
                  ? 4
                  : 3;
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 200),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  final avatar = avatars[index];
                  return _AvatarTile(avatar: avatar);
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(child: Text('加载失败: $e')),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarTile extends ConsumerWidget {
  const _AvatarTile({required this.avatar});

  final PhigrosAvatar avatar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        final args = PhigrosAvatarDetailArgs(avatar: avatar);
        pushDetailPage(
          context,
          PhigrosAvatarDetailPage(args: args),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatar.avatarUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 64,
                height: 64,
                color: colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.person_outline),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            avatar.avatarName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
