import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/games/phigros/pages/collection_file_detail_page.dart';
import 'package:rank_hub/games/phigros/phigros_resources.dart';
import 'package:rank_hub/models/phigros/collection.dart';

class PhigrosCollectionListView extends ConsumerWidget {
  const PhigrosCollectionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(
      resourceProviderOf<List<PhigrosCollection>>(
        phigrosCollectionListResourceKey,
      ),
    );
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> refresh() async {
      await ref.read(
        refreshResourceProviderOf<List<PhigrosCollection>>(
          phigrosCollectionListResourceKey,
        ).future,
      );
    }

    return collectionsAsync.when(
      data: (collections) {
        if (collections.isEmpty) {
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
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无藏品数据',
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
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 200),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return _CollectionCard(collection: collection);
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

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.collection});

  final PhigrosCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = collection.title.isNotEmpty
        ? collection.title
        : (collection.name.isNotEmpty ? collection.name : '未命名藏品');
    final subtitle = collection.subTitle;
    final fileCount = collection.files.length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CoverBanner(
            url: collection.coverUrl,
            title: title,
            subTitle: subtitle,
          ),
          ExpansionTile(
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              subtitle.isEmpty ? '共 $fileCount 条' : '$subtitle · $fileCount 条',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              if (collection.files.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('暂无条目')),
                )
              else
                ...collection.files.map(
                  (file) => _CollectionFileTile(
                    file: file,
                    onTap: () {
                      final args = CollectionFileDetailArgs(
                        collectionTitle: title,
                        collectionSubTitle: subtitle,
                        coverUrl: collection.coverUrl,
                        file: file,
                      );
                      pushDetailPage(
                        context,
                        CollectionFileDetailPage(args: args),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverBanner extends StatelessWidget {
  const _CoverBanner({
    required this.url,
    required this.title,
    required this.subTitle,
  });

  final String url;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const height = 140.0;
    if (url.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: const Icon(Icons.photo_outlined, size: 36),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: url,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: height,
              color: colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, __, ___) => Container(
              height: height,
              color: colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined, size: 36),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : '未命名藏品',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subTitle.isNotEmpty)
                  Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionFileTile extends StatelessWidget {
  const _CollectionFileTile({required this.file, required this.onTap});

  final PhigrosCollectionFile file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      if (file.date.isNotEmpty) file.date,
      if (file.supervisor.isNotEmpty) file.supervisor,
      if (file.category.isNotEmpty) file.category,
    ];

    return ListTile(
      title: Text(file.name.isNotEmpty ? file.name : '未命名条目'),
      subtitle: subtitleParts.isEmpty
          ? null
          : Text(
              subtitleParts.join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: file.subIndex > 0 ? Text('#${file.subIndex}') : null,
      onTap: onTap,
    );
  }
}
