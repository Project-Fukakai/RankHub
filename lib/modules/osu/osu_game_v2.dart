import 'package:flutter/material.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/game_descriptor.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/modules/osu/pages/osu_beatmap_list_page.dart';

/// osu! 游戏（新架构版本）
/// 实现 core/game.dart 的 Game 接口
class OsuGameV2 implements Game {
  @override
  final GameId id = const GameId(
    name: 'osu',
    version: '1.0',
    platform: 'osu',
    region: 'Global',
  );

  @override
  final String name = 'osu!';

  @override
  GameDescriptor get descriptor => GameDescriptor(
        // 资料库页面（原 buildWikiViews）
        libraryPages: [
          PageDescriptor(
            title: '谱面商店',
            icon: Icons.storefront,
            builder: (context) => const OsuBeatmapListPage(),
            requiresAccount: false, // 谱面商店不需要登录
          ),
        ],

        // 成绩页面（原 buildRankViews）
        scorePages: [
          PageDescriptor(
            title: '最近游玩',
            icon: Icons.history,
            builder: (context) => const _OsuRecentPlaysTab(),
            requiresAccount: true, // 成绩需要登录
          ),
          PageDescriptor(
            title: '最佳表现',
            icon: Icons.emoji_events_outlined,
            builder: (context) => const _OsuBestPlaysTab(),
            requiresAccount: true,
          ),
          PageDescriptor(
            title: '第一名排行',
            icon: Icons.looks_one_outlined,
            builder: (context) => const _OsuFirstPlaysTab(),
            requiresAccount: true,
          ),
        ],

        // 工具箱页面
        toolboxPages: [
          PageDescriptor(
            title: '工具',
            icon: Icons.construction,
            builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: const Text('Mods 计算器'),
                    subtitle: const Text('计算不同 Mods 组合的效果'),
                    onTap: () {
                      // TODO: 导航到 Mods 页面
                    },
                  ),
                ],
              ),
            ),
            requiresAccount: false,
          ),
        ],

        // 个人信息页面（原 buildPlayerInfoCard）
        profilePages: [
          PageDescriptor(
            title: '玩家信息',
            icon: Icons.person,
            builder: (context) => const Center(
              child: Text('玩家信息卡片'),
              // TODO: 使用 OsuPlayerInfoCard widget
            ),
            requiresAccount: true,
          ),
        ],

        // 资源和工具（暂时为空）
        resources: [],
        tools: [],

        // 游戏元数据
        iconUrl: 'https://osu.ppy.sh/favicon.ico',
        iconData: Icons.circle_outlined,
        themeColor: Colors.pink,
        supportedPlatformIds: ['osu'],
      );
}

// ========== Placeholder Widgets ==========

class _OsuRecentPlaysTab extends StatelessWidget {
  const _OsuRecentPlaysTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('最近游玩'),
          SizedBox(height: 8),
          Text('开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _OsuBestPlaysTab extends StatelessWidget {
  const _OsuBestPlaysTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('最佳表现'),
          SizedBox(height: 8),
          Text('开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _OsuFirstPlaysTab extends StatelessWidget {
  const _OsuFirstPlaysTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.looks_one_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('第一名排行'),
          SizedBox(height: 8),
          Text('开发中...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
