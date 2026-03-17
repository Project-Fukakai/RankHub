import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rank_hub/models/phigros/collection.dart';

class CollectionFileDetailArgs {
  final String collectionTitle;
  final String collectionSubTitle;
  final String coverUrl;
  final PhigrosCollectionFile file;

  const CollectionFileDetailArgs({
    required this.collectionTitle,
    required this.collectionSubTitle,
    required this.coverUrl,
    required this.file,
  });
}

class CollectionFileDetailPage extends StatelessWidget {
  final CollectionFileDetailArgs args;

  const CollectionFileDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final file = args.file;
    final content = _normalizeContent(file.content);
    final subtitleParts = <String>[
      if (file.date.isNotEmpty) file.date,
      if (file.supervisor.isNotEmpty) file.supervisor,
      if (file.category.isNotEmpty) file.category,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(file.name.isNotEmpty ? file.name : '藏品条目')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CoverBanner(
            coverUrl: args.coverUrl,
            title: args.collectionTitle,
            subTitle: args.collectionSubTitle,
            date: file.date,
            supervisor: file.supervisor,
            category: file.category,
          ),
          const SizedBox(height: 16),
          if (subtitleParts.isNotEmpty)
            Text(
              subtitleParts.join(' · '),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (file.subIndex > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '条目序号 #${file.subIndex}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (file.properties.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                file.properties,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            content.isNotEmpty ? content : '暂无内容',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _normalizeContent(String raw) {
    return raw.replaceAll('\\r', '\r').replaceAll('\\n', '\n');
  }
}

class _CoverBanner extends StatelessWidget {
  const _CoverBanner({
    required this.coverUrl,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.supervisor,
    required this.category,
  });

  final String coverUrl;
  final String title;
  final String subTitle;
  final String date;
  final String supervisor;
  final String category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _CoverImage(
      url: coverUrl,
      title: title,
      subTitle: subTitle,
      date: date,
      supervisor: supervisor,
      category: category,
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.url,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.supervisor,
    required this.category,
  });

  final String url;
  final String title;
  final String subTitle;
  final String date;
  final String supervisor;
  final String category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const height = 180.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          if (url.isEmpty)
            Container(
              width: double.infinity,
              height: height,
              color: colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.photo_outlined, size: 40),
            )
          else
            CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: double.infinity,
                height: height,
                color: colorScheme.surfaceContainerHighest,
              ),
              errorWidget: (_, __, ___) => Container(
                width: double.infinity,
                height: height,
                color: colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined, size: 40),
              ),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : '未命名藏品',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subTitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (date.isNotEmpty) _MetaChip(label: '收集时间', value: date),
                    if (supervisor.isNotEmpty)
                      _MetaChip(label: '保管单位', value: supervisor),
                    if (category.isNotEmpty)
                      _MetaChip(label: '等级', value: category),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}
