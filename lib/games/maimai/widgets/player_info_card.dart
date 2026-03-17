import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';

/// 玩家信息卡片
class PlayerInfoCard extends StatelessWidget {
  final MaimaiPlayer player;

  const PlayerInfoCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (player.frame != null)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl:
                    'https://assets2.lxns.net/maimai/frame/${player.frame!.id}.png',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          if (player.namePlate != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CachedNetworkImage(
                imageUrl:
                    'https://assets2.lxns.net/maimai/plate/${player.namePlate!.id}.png',
                fit: BoxFit.fitWidth,
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          if (player.frame != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.centerRight,
                    colors: [
                      colorScheme.surface.withValues(alpha: 0.9),
                      colorScheme.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          // 内容区域
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(context),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (player.trophy != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                player.trophy!.name,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            player.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: player.friendCode.toString(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('好友码已复制'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '好友码: ${player.friendCode}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // DX 评分（独立一行）
                Container(
                  decoration: BoxDecoration(
                    gradient: _getRatingGradient(player.rating),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(3), // 描边宽度
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      'DX评分 ${player.rating}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCompactRankItem(
                      context: context,
                      imageUrl: player.courseRankImageUrl,
                    ),
                    const SizedBox(width: 8),
                    _buildCompactRankItem(
                      context: context,
                      imageUrl: player.classRankImageUrl,
                    ),
                    const SizedBox(width: 8),
                    _buildCompactStarItem(context: context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 根据 Rating 获取渐变背景
  LinearGradient _getRatingGradient(int rating) {
    if (rating < 0) {
      return const LinearGradient(colors: [Colors.grey, Colors.grey]);
    } else if (rating <= 999) {
      return const LinearGradient(
        colors: [Color(0xFFBDBDBD), Color(0xFFE0E0E0)],
      ); // 浅灰色
    } else if (rating <= 1999) {
      return const LinearGradient(colors: [Colors.blue, Colors.blueAccent]);
    } else if (rating <= 3999) {
      return const LinearGradient(colors: [Colors.green, Colors.lightGreen]);
    } else if (rating <= 6999) {
      return const LinearGradient(colors: [Colors.yellow, Colors.orange]);
    } else if (rating <= 9999) {
      return const LinearGradient(colors: [Colors.red, Colors.redAccent]);
    } else if (rating <= 11999) {
      return const LinearGradient(colors: [Colors.purple, Colors.deepPurple]);
    } else if (rating <= 12999) {
      return const LinearGradient(
        colors: [Color(0xFFCD7F32), Color(0xFFB87333)],
      ); // 铜色
    } else if (rating <= 13999) {
      return const LinearGradient(colors: [Colors.grey, Colors.blueGrey]); // 银色
    } else if (rating <= 14499) {
      return const LinearGradient(
        colors: [Colors.amber, Colors.orangeAccent],
      ); // 金色
    } else if (rating <= 14999) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 252, 208, 122),
          Color.fromARGB(255, 252, 255, 160),
        ],
      ); // 白金色
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 47, 214, 184),
          Color.fromARGB(255, 56, 91, 187),
          Color.fromARGB(255, 180, 67, 188),
        ],
      ); // 彩虹色
    }
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: player.icon != null
            ? CachedNetworkImage(
                imageUrl:
                    'https://assets2.lxns.net/maimai/icon/${player.icon!.id}.png',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 35,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : Icon(Icons.person, size: 35, color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildCompactRankItem({
    required BuildContext context,
    required String imageUrl,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 32,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
          height: 32,
          width: 32,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 48,
          width: 48,
          color: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.error_outline,
            size: 20,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStarItem({required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: player.starIconUrl,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) =>
                Icon(Icons.star, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(height: 2),
          Text(
            '×${player.star}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
