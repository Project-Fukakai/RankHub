import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/game_descriptor.dart';
import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/phigros/models/phigros_b30_export_args.dart';
import 'package:rank_hub/games/phigros/phigros_resource_definitions.dart';
import 'package:rank_hub/games/phigros/phigros_resources.dart';
import 'package:rank_hub/games/phigros/views/phigros_avatar_list_view.dart';
import 'package:rank_hub/games/phigros/views/phigros_b30_view.dart';
import 'package:rank_hub/games/phigros/views/phigros_collection_list_view.dart';
import 'package:rank_hub/games/phigros/views/phigros_record_list_view.dart';
import 'package:rank_hub/games/phigros/views/phigros_song_list_view.dart';
import 'package:rank_hub/games/phigros/widgets/phigros_player_info_card.dart';
import 'package:rank_hub/games/phigros/pages/phigros_b30_export_page.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/player_summary.dart';

/// Phigros 游戏（新架构版本）
/// 实现 core/game.dart 的 Game 接口
class PhigrosGameV2 implements Game {
  @override
  final GameId id = const GameId(
    name: 'phigros',
    version: '3.0',
    platform: 'phigros',
    region: 'CN',
  );

  @override
  final String name = 'Phigros';

  @override
  GameDescriptor get descriptor => GameDescriptor(
        // 资料库页面（原 buildWikiViews）
        libraryPages: [
          PageDescriptor(
            title: '曲目',
            icon: Icons.library_music_outlined,
            builder: (context) => const PhigrosSongListView(),
            requiresAccount: false, // 曲库不需要登录
          ),
          PageDescriptor(
            title: '藏品',
            icon: Icons.collections_bookmark_outlined,
            builder: (context) => const PhigrosCollectionListView(),
            requiresAccount: false,
          ),
          PageDescriptor(
            title: '头像',
            icon: Icons.face_outlined,
            builder: (context) => const PhigrosAvatarListView(),
            requiresAccount: false,
          ),
        ],

        // 成绩页面（原 buildRankViews）
        scorePages: [
          PageDescriptor(
            title: 'B30',
            icon: Icons.workspace_premium,
            builder: (context) => const PhigrosB30View(),
            requiresAccount: true, // 成绩需要登录
          ),
          PageDescriptor(
            title: '全部成绩',
            icon: Icons.poll,
            builder: (context) => const PhigrosRecordListView(),
            requiresAccount: true,
          ),
        ],

        // 工具箱页面
        toolboxPages: [
          PageDescriptor(
            title: '工具',
            icon: Icons.construction,
            builder: (context) => Consumer(
              builder: (context, ref, _) {
                final accountState = ref.watch(accountViewModelProvider);
                final account = accountState.currentAccount;

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.download),
                        title: const Text('导出 B30'),
                        subtitle: const Text('导出 B30 成绩为图片'),
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          if (account == null) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('请先登录账号')),
                            );
                            return;
                          }

                      List<PhigrosGameRecord> records;
                      try {
                        records = await ref.read(
                          resourceProviderOf<List<PhigrosGameRecord>>(
                            phigrosRecordListResourceKey,
                          ).future,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('加载成绩失败: $e')),
                        );
                        return;
                      }

                      if (records.isEmpty) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('暂无可导出的成绩')),
                        );
                        return;
                      }
                      PhigrosPlayerSummary? summary;
                      try {
                        summary = await ref.read(
                          resourceProviderOf<PhigrosPlayerSummary>(
                            phigrosPlayerSummaryResourceKey,
                          ).future,
                        );
                      } catch (_) {}
                      final stats = _calculateExportStats(records);

                          if (!context.mounted) return;
                          final args = PhigrosB30ExportArgs(
                            ezCount: stats.ezCount,
                            ezC: stats.ezC,
                            ezFC: stats.ezFC,
                            ezPhi: stats.ezPhi,
                            hdCount: stats.hdCount,
                            hdC: stats.hdC,
                            hdFC: stats.hdFC,
                            hdPhi: stats.hdPhi,
                            inCount: stats.inCount,
                            inC: stats.inC,
                            inFC: stats.inFC,
                            inPhi: stats.inPhi,
                            atCount: stats.atCount,
                            atC: stats.atC,
                            atFC: stats.atFC,
                            atPhi: stats.atPhi,
                            fcCount: stats.fcCount,
                            phiCount: stats.phiCount,
                            challengeMode: summary?.challengeModeRank,
                            challengeRankLevel: summary?.challengeRankLevel,
                            avatarName: summary?.avatarName ?? '',
                          );
                          pushDetailPage(
                            context,
                            PhigrosB30ExportPage(
                              ezCount: args.ezCount,
                              ezC: args.ezC,
                              ezFC: args.ezFC,
                              ezPhi: args.ezPhi,
                              hdCount: args.hdCount,
                              hdC: args.hdC,
                              hdFC: args.hdFC,
                              hdPhi: args.hdPhi,
                              inCount: args.inCount,
                              inC: args.inC,
                              inFC: args.inFC,
                              inPhi: args.inPhi,
                              atCount: args.atCount,
                              atC: args.atC,
                              atFC: args.atFC,
                              atPhi: args.atPhi,
                              fcCount: args.fcCount,
                              phiCount: args.phiCount,
                              challengeMode: args.challengeMode,
                              challengeRankLevel: args.challengeRankLevel,
                              avatarName: args.avatarName,
                            ),
                            replaceOnThreeColumn: true,
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
            builder: (context) => const _PhigrosProfilePage(),
            requiresAccount: true,
          ),
        ],

        // 资源和工具（暂时为空）
        resources: phigrosResourceDefinitions,
        tools: [],

        // 游戏元数据
        iconUrl:
            'https://img.tapimg.com/market/images/9000b8b031deabbd424b7f2f530ee162.png',
        iconData: Icons.stars_outlined,
        themeColor: Colors.deepPurple,
        supportedPlatformIds: ['phigros'],
      );
}

class _PhigrosProfilePage extends ConsumerWidget {
  const _PhigrosProfilePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountViewModelProvider);
    final account = accountState.currentAccount;
    if (account == null) {
      return const Center(child: Text('请先登录账号'));
    }

    final recordsState = ref.watch(
      resourceProviderOf<List<PhigrosGameRecord>>(phigrosRecordListResourceKey),
    );
    final summaryState = ref.watch(
      resourceProviderOf<PhigrosPlayerSummary>(
        phigrosPlayerSummaryResourceKey,
      ),
    );

    if (recordsState.isLoading || summaryState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recordsState.hasError) {
      return Center(child: Text('加载失败: ${recordsState.error}'));
    }

    final records = recordsState.value ?? const <PhigrosGameRecord>[];
    if (records.isEmpty) {
      return const Center(child: Text('暂无玩家信息'));
    }

    final summary = summaryState.value;
    return SingleChildScrollView(
      child: PhigrosPlayerInfoCard(
        records: records,
        summary: summary,
      ),
    );
  }
}

_PhigrosExportStats _calculateExportStats(
  List<PhigrosGameRecord> records,
) {
  int phiCount = 0;
  int fcCount = 0;
  int ezCount = 0, ezC = 0, ezFC = 0, ezPhi = 0;
  int hdCount = 0, hdC = 0, hdFC = 0, hdPhi = 0;
  int inCount = 0, inC = 0, inFC = 0, inPhi = 0;
  int atCount = 0, atC = 0, atFC = 0, atPhi = 0;

  for (final record in records) {
    final isPhi = record.score >= 1000000;
    final isFC = record.fc;
    final isC = record.acc >= 70.0;

    if (isPhi) phiCount++;
    if (isFC) fcCount++;

    switch (record.level) {
      case 'EZ':
        ezCount++;
        if (isC) ezC++;
        if (isFC) ezFC++;
        if (isPhi) ezPhi++;
        break;
      case 'HD':
        hdCount++;
        if (isC) hdC++;
        if (isFC) hdFC++;
        if (isPhi) hdPhi++;
        break;
      case 'IN':
        inCount++;
        if (isC) inC++;
        if (isFC) inFC++;
        if (isPhi) inPhi++;
        break;
      case 'AT':
        atCount++;
        if (isC) atC++;
        if (isFC) atFC++;
        if (isPhi) atPhi++;
        break;
    }
  }

  return _PhigrosExportStats(
    totalRks: 0,
    phiCount: phiCount,
    fcCount: fcCount,
    ezCount: ezCount,
    ezC: ezC,
    ezFC: ezFC,
    ezPhi: ezPhi,
    hdCount: hdCount,
    hdC: hdC,
    hdFC: hdFC,
    hdPhi: hdPhi,
    inCount: inCount,
    inC: inC,
    inFC: inFC,
    inPhi: inPhi,
    atCount: atCount,
    atC: atC,
    atFC: atFC,
    atPhi: atPhi,
  );
}

class _PhigrosExportStats {
  final double totalRks;
  final int phiCount;
  final int fcCount;
  final int ezCount;
  final int ezC;
  final int ezFC;
  final int ezPhi;
  final int hdCount;
  final int hdC;
  final int hdFC;
  final int hdPhi;
  final int inCount;
  final int inC;
  final int inFC;
  final int inPhi;
  final int atCount;
  final int atC;
  final int atFC;
  final int atPhi;

  const _PhigrosExportStats({
    required this.totalRks,
    required this.phiCount,
    required this.fcCount,
    required this.ezCount,
    required this.ezC,
    required this.ezFC,
    required this.ezPhi,
    required this.hdCount,
    required this.hdC,
    required this.hdFC,
    required this.hdPhi,
    required this.inCount,
    required this.inC,
    required this.inFC,
    required this.inPhi,
    required this.atCount,
    required this.atC,
    required this.atFC,
    required this.atPhi,
  });
}
