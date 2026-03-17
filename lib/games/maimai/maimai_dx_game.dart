import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/game_descriptor.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/games/maimai/pages/collection_progress_page.dart';
import 'package:rank_hub/games/maimai/services/maimai_export_service.dart';
import 'package:rank_hub/games/maimai/tabs/best50_tab.dart';
import 'package:rank_hub/games/maimai/tabs/collections_tab.dart';
import 'package:rank_hub/games/maimai/tabs/kaleidxscope_tab.dart';
import 'package:rank_hub/games/maimai/tabs/records_tab.dart';
import 'package:rank_hub/games/maimai/tabs/songs_tab.dart';
import 'package:rank_hub/games/maimai/maimai_resource_definitions.dart';
import 'package:rank_hub/games/maimai/viewmodels/maimai_player_view_model.dart';
import 'package:rank_hub/games/maimai/widgets/player_info_card.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/maimai/pages/net_sync_page.dart';
import 'package:rank_hub/games/maimai/pages/random_song_picker_page.dart';

/// 舞萌DX 游戏（新架构版本）
/// 实现 core/game.dart 的 Game 接口
class MaimaiDXGameV2 implements Game {
  @override
  final GameId id = const GameId(
    name: 'maimai_dx',
    version: '1.53',
    platform: 'arcade',
    region: 'CN',
  );

  @override
  final String name = '舞萌DX';

  @override
  GameDescriptor get descriptor => GameDescriptor(
    // 资料库页面（原 buildWikiViews）
    libraryPages: [
      PageDescriptor(
        title: '曲目',
        icon: Icons.library_music_outlined,
        builder: (context) => const SongsTab(),
        requiresAccount: false, // 曲库不需要登录
      ),
      PageDescriptor(
        title: '收藏品',
        icon: Icons.collections_outlined,
        builder: (context) => const CollectionsTab(),
        requiresAccount: false,
      ),
      PageDescriptor(
        title: '万花筒',
        icon: Icons.door_front_door,
        builder: (context) => const KaleidxscopeTab(),
        requiresAccount: false,
      ),
      PageDescriptor(
        title: '区域',
        icon: Icons.map_outlined,
        builder: (context) => const Center(child: Text('区域页面开发中...')),
        requiresAccount: false,
      ),
    ],

    // 成绩页面（原 buildRankViews）
    scorePages: [
      PageDescriptor(
        title: '全部成绩',
        icon: Icons.poll,
        builder: (context) => const RecordsTab(),
        requiresAccount: true, // 成绩需要登录
      ),
      PageDescriptor(
        title: 'B50',
        icon: Icons.flag,
        builder: (context) => const Best50Tab(),
        requiresAccount: true,
      ),
      PageDescriptor(
        title: '藏品进度',
        icon: Icons.collections_bookmark,
        builder: (context) => const CollectionProgressPage(),
        requiresAccount: true,
      ),
    ],

    // 工具箱页面（原 LxnsPlatform.getCustomFeatures）
    toolboxPages: [
      PageDescriptor(
        title: '工具',
        icon: Icons.construction,
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            final account = ref.watch(accountViewModelProvider).currentAccount;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('从 NET 同步成绩'),
                    subtitle: const Text('扫描 QR Code 或输入 User ID'),
                    onTap: () {
                      if (account == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请先登录账号')),
                        );
                        return;
                      }
                      pushDetailPage(
                        context,
                        NetSyncPage(account: account),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('导出成绩'),
                    subtitle: const Text('导出为 CSV 或 JSON 文件'),
                    onTap: () {
                      MaimaiExportService.instance.showExportDialog(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.casino),
                    title: const Text('随机选曲'),
                    subtitle: const Text('根据条件随机选择曲目'),
                    onTap: () {
                      pushDetailPage(
                        context,
                        const RandomSongPickerPage(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        requiresAccount: false,
      ),
    ],

    // 个人信息页面（原 buildPlayerInfoCard）
    profilePages: [
      PageDescriptor(
        title: '玩家信息',
        icon: Icons.person,
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(maimaiPlayerViewModelProvider);
            final player = state.player;

            if (player == null) {
              return const Center(child: Text('暂无玩家信息'));
            }

            return SingleChildScrollView(
              child: PlayerInfoCard(player: player),
            );
          },
        ),
        requiresAccount: true,
      ),
    ],

    // 资源和工具
    resources: maimaiResourceDefinitions,
    tools: [],

    // 游戏元数据
    iconUrl: 'https://map.bemanicn.com/imgs/titles/maimaidx.png',
    iconData: Icons.music_note_outlined,
    themeColor: Colors.pink,
    supportedPlatformIds: ['lxns', 'divingfish'], // 支持多个数据源
  );
}
