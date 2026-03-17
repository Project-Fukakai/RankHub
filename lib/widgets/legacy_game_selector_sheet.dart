import 'package:flutter/material.dart';
import 'package:rank_hub/models/game.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 旧架构游戏选择器底部弹窗（IGame）
class LegacyGameSelectorSheet {
  static Future<void> show(
    BuildContext context, {
    required List<IGame> games,
    required IGame? selectedGame,
    required Function(IGame) onGameSelected,
    String title = '选择游戏',
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LegacyGameSelectorContent(
        games: games,
        selectedGame: selectedGame,
        onGameSelected: onGameSelected,
        title: title,
      ),
    );
  }
}

class _LegacyGameSelectorContent extends StatelessWidget {
  final List<IGame> games;
  final IGame? selectedGame;
  final Function(IGame) onGameSelected;
  final String title;

  const _LegacyGameSelectorContent({
    required this.games,
    required this.selectedGame,
    required this.onGameSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 标题栏
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: '关闭',
                ),
              ],
            ),
          ),

          // 游戏列表
          Flexible(
            child: games.isEmpty
                ? _buildEmptyState(context)
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 8,
                          ),
                          itemCount: games.length,
                          itemBuilder: (context, index) {
                            final game = games[index];
                            final isSelected = game.id == selectedGame?.id;

                            return _buildGameTile(
                              context,
                              game,
                              isSelected,
                              () {
                                onGameSelected(game);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                      // 提示信息
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: Text(
                          '没有找到需要的游戏？你可能需要切换平台',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTile(
    BuildContext context,
    IGame game,
    bool isSelected,
    VoidCallback onTap,
  ) {
    // 如果游戏提供了自定义列表项，使用自定义样式
    final customTile = game.buildSelectorListTile(context, isSelected, onTap);
    if (customTile != null) {
      return customTile;
    }

    // 默认样式
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 游戏图标
              if (game.iconUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: game.iconUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 48,
                      height: 48,
                      color: colorScheme.surfaceContainerHigh,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: game.color ?? colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(game.icon, color: Colors.white),
                    ),
                  ),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: game.color ?? colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(game.icon, color: Colors.white),
                ),

              const SizedBox(width: 16),

              // 游戏信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                    if (game.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        game.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer.withOpacity(0.7)
                              : colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // 选中指示器
              if (isSelected) ...[
                const SizedBox(width: 12),
                Icon(Icons.check_circle, color: colorScheme.primary, size: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.games_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无可用游戏',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请先添加账号',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
