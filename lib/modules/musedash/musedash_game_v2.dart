import 'package:flutter/material.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/game_descriptor.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/modules/musedash/pages/musedash_wiki_page.dart';
import 'package:rank_hub/modules/musedash/pages/musedash_characters_page.dart';
import 'package:rank_hub/modules/musedash/pages/musedash_elfins_page.dart';
import 'package:rank_hub/modules/musedash/pages/musedash_scores_page.dart';
import 'package:rank_hub/modules/musedash/pages/musedash_all_scores_page.dart';

/// Muse Dash 游戏（新架构版本）
/// 实现 core/game.dart 的 Game 接口
class MuseDashGameV2 implements Game {
  @override
  final GameId id = const GameId(
    name: 'musedash',
    version: '4.0',
    platform: 'musedash',
    region: 'Global',
  );

  @override
  final String name = 'Muse Dash';

  @override
  GameDescriptor get descriptor => GameDescriptor(
        // 资料库页面（原 buildWikiViews）
        libraryPages: [
          PageDescriptor(
            title: '曲库',
            icon: Icons.library_music,
            builder: (context) => const MuseDashWikiPage(),
            requiresAccount: false, // 曲库不需要登录
          ),
          PageDescriptor(
            title: '角色',
            icon: Icons.person,
            builder: (context) => const MuseDashCharactersPage(),
            requiresAccount: false,
          ),
          PageDescriptor(
            title: '精灵',
            icon: Icons.pets,
            builder: (context) => const MuseDashElfinsPage(),
            requiresAccount: false,
          ),
        ],

        // 成绩页面（原 buildRankViews）
        scorePages: [
          PageDescriptor(
            title: 'Best 30',
            icon: Icons.emoji_events,
            builder: (context) => const MuseDashScoresPage(),
            requiresAccount: true, // 成绩需要登录
          ),
          PageDescriptor(
            title: '所有成绩',
            icon: Icons.list,
            builder: (context) => const MuseDashAllScoresPage(),
            requiresAccount: true,
          ),
        ],

        // 工具箱页面（暂无）
        toolboxPages: [],

        // 个人信息页面（原 buildPlayerInfoCard）
        profilePages: [
          PageDescriptor(
            title: '玩家信息',
            icon: Icons.person,
            builder: (context) => const Center(
              child: Text('玩家信息卡片'),
              // TODO: 使用 PlayerInfoCard widget
            ),
            requiresAccount: true,
          ),
        ],

        // 资源和工具（暂时为空）
        resources: [],
        tools: [],

        // 游戏元数据
        iconUrl: 'https://musedash.moe/img/icons/android-chrome-512x512.png',
        iconData: Icons.music_note,
        themeColor: Colors.pink,
        supportedPlatformIds: ['musedash'],
      );
}
