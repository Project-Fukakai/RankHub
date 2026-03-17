import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/games/phigros/viewmodels/phigros_view_model.dart';
import 'package:rank_hub/games/phigros/widgets/phigros_record_list_item.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import 'package:rank_hub/games/phigros/models/phigros_b30_export_args.dart';
import 'package:rank_hub/games/phigros/pages/phigros_b30_export_page.dart';

/// Phigros B30成绩视图
class PhigrosB30View extends ConsumerStatefulWidget {
  const PhigrosB30View({super.key});

  @override
  ConsumerState<PhigrosB30View> createState() => _PhigrosB30ViewState();
}

class _PhigrosB30ViewState extends ConsumerState<PhigrosB30View> {
  String? _loadedAccountId;
  ProviderSubscription<AccountState>? _accountSubscription;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(phigrosViewModelProvider.notifier);
    Future.microtask(() => viewModel.loadSongs());

    _accountSubscription = ref.listenManual<AccountState>(
      accountViewModelProvider,
      (previous, next) {
        final account = next.currentAccount;
        if (account == null) return;
        final accountId = extractPhigrosAccountIdentifier(account);
        if (_loadedAccountId == accountId) return;
        _loadedAccountId = accountId;

        Future.microtask(() => viewModel.loadRecords());
      },
    );

    final currentAccount = ref.read(accountViewModelProvider).currentAccount;
    if (currentAccount != null) {
      final accountId = extractPhigrosAccountIdentifier(currentAccount);
      _loadedAccountId = accountId;
      Future.microtask(() => viewModel.loadRecords());
    }
  }

  @override
  void dispose() {
    _accountSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(phigrosViewModelProvider.notifier);
    final state = ref.watch(phigrosViewModelProvider);
    final accountState = ref.watch(accountViewModelProvider);
    final account = accountState.currentAccount;
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> refresh() async {
      if (account == null) return;
      await viewModel.loadRecords(forceRefresh: true);
    }

    if (state.isLoadingRecords) {
      return const Center(child: CircularProgressIndicator());
    }

    final b30Records = viewModel.getB30Records();
    final phis = b30Records['phi'] ?? [];
    final b30s = b30Records['best'] ?? [];
    final filledPhis = List.generate(
      3,
      (i) => i < phis.length ? phis[i] : null,
    );
    final filledB30s = List.generate(
      27,
      (i) => i < b30s.length ? b30s[i] : null,
    );

    Widget mainContent;
    if (phis.isEmpty && b30s.isEmpty) {
      mainContent = RefreshIndicator(
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
                    Icons.music_off,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无成绩数据',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      mainContent = RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 200),
          children: [
            _buildPlayerInfoCard(context, state.records, viewModel, state),
            // P1-P3 section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: const Text(
                      'P1-P3',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Phi评级歌曲前三',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // P1, P2, P3
            ...filledPhis.map((it) => PhigrosRecordListItem(record: it)),

            // B1-B27 section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple),
                    ),
                    child: const Text(
                      'B1-B27',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '剩余最佳成绩',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // B1-B27
            ...filledB30s.map((it) => PhigrosRecordListItem(record: it)),
          ],
        ),
      );
    }

    final records = state.records;
    final stats = _calculateStats(records, viewModel);
    final summary = state.playerSummary;
    return Stack(
      children: [
        mainContent,
        Positioned(
          bottom: 120,
          right: 24,
          child: FloatingActionButton.extended(
            onPressed: records.isEmpty
                ? null
                : () {
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
            icon: const Icon(Icons.file_download),
            label: const Text('导出B30图片'),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerInfoCard(
    BuildContext context,
    List<PhigrosGameRecord> records,
    PhigrosViewModel viewModel,
    PhigrosState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    final stats = _calculateStats(records, viewModel);
    final summary = state.playerSummary;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RKS',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats.totalRks.toStringAsFixed(4),
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (summary != null && summary.challengeModeRank > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getChallengeColor(
                            summary.challengeRankLevel,
                          ).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getChallengeColor(
                              summary.challengeRankLevel,
                            ),
                          ),
                        ),
                        child: Text(
                          summary.challengeDifficulty.toString(),
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getChallengeColor(
                              summary.challengeRankLevel,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDifficultyStats(
                    'EZ',
                    stats.ezCount,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDifficultyStats(
                    'HD',
                    stats.hdCount,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDifficultyStats(
                    'IN',
                    stats.inCount,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDifficultyStats(
                    'AT',
                    stats.atCount,
                    colorScheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatChip(
                    'FC',
                    stats.fcCount,
                    Colors.blue,
                    colorScheme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatChip(
                    'Phi',
                    stats.phiCount,
                    Colors.amber,
                    colorScheme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyStats(
    String level,
    int count,
    ColorScheme colorScheme,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            level,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    String label,
    int count,
    Color color,
    ColorScheme colorScheme,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  _PlayerStats _calculateStats(
    List<PhigrosGameRecord> records,
    PhigrosViewModel viewModel,
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

    return _PlayerStats(
      totalRks: viewModel.calculatePersonalRks(),
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

  Color _getChallengeColor(int level) {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      case 4:
        return Colors.amber;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _PlayerStats {
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

  _PlayerStats({
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
