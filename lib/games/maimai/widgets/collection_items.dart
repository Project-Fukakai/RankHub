import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';

/// 收藏品列表项
class CollectionListItem extends StatelessWidget {
  final MaimaiCollection collection;

  const CollectionListItem({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    // 根据收藏品类型选择不同的展示方式
    switch (collection.collectionType) {
      case 'trophy':
        return TrophyItem(collection: collection);
      case 'icon':
        return IconItem(collection: collection);
      case 'plate':
      case 'frame':
        return CardItem(collection: collection);
      default:
        return DefaultItem(collection: collection);
    }
  }
}

/// 称号展示 - 使用 Chip
class TrophyItem extends StatelessWidget {
  final MaimaiCollection collection;

  const TrophyItem({super.key, required this.collection});

  Color _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) {
      return Colors.grey;
    }

    // 根据称号类型返回固定颜色
    switch (colorStr.toLowerCase()) {
      case 'normal':
        return Colors.grey.shade300; // 普通 - 灰色
      case 'bronze':
        return const Color(0xFFCD7F32); // 铜 - 铜色
      case 'silver':
        return const Color(0xFFC0C0C0); // 银 - 银色
      case 'gold':
        return const Color(0xFFFFD700); // 金 - 金色
      case 'rainbow':
        return Colors.purple.shade300; // 虹 - 紫色（渐变色的代表）
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(collection.color);
    final isLight = bgColor.computeLuminance() > 0.5;
    final textColor = isLight ? Colors.black : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            avatar: Icon(Icons.emoji_events, size: 18, color: textColor),
            label: Text(
              collection.name + (collection.color ?? ''),
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            backgroundColor: bgColor,
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          if (collection.description != null &&
              collection.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                collection.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 头像展示 - 使用 ListTile
class IconItem extends StatelessWidget {
  final MaimaiCollection collection;

  const IconItem({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconUrl =
        'https://assets2.lxns.net/maimai/icon/${collection.collectionId}.png';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: iconUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_circle,
                  color: colorScheme.onSecondaryContainer,
                  size: 30,
                ),
              );
            },
          ),
        ),
        title: Text(
          collection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: collection.description != null
            ? Text(
                collection.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              )
            : null,
      ),
    );
  }
}

/// 姓名框和背景展示 - 使用卡片（上半图片，下半信息）
class CardItem extends StatelessWidget {
  final MaimaiCollection collection;

  const CardItem({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPlate = collection.collectionType == 'plate';
    final imageUrl = isPlate
        ? 'https://assets2.lxns.net/maimai/plate/${collection.collectionId}.png'
        : 'https://assets2.lxns.net/maimai/frame/${collection.collectionId}.png';

    // 姓名框: 720x116 (宽高比 ~6.2:1)
    // 背景: 1080x452 (宽高比 ~2.4:1)
    final aspectRatio = isPlate ? 720 / 116 : 1080 / 452;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片部分 - 使用 AspectRatio 确保正确显示
          AspectRatio(
            aspectRatio: aspectRatio,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) {
                return Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      isPlate ? Icons.style : Icons.crop_free,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
          // 信息部分
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (collection.description != null &&
                    collection.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    collection.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (collection.genre != null) ...[
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(collection.genre!),
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 默认展示
class DefaultItem extends StatelessWidget {
  final MaimaiCollection collection;

  const DefaultItem({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.collections,
            color: colorScheme.onSecondaryContainer,
            size: 30,
          ),
        ),
        title: Text(
          collection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: collection.description != null
            ? Text(
                collection.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              )
            : null,
      ),
    );
  }
}
