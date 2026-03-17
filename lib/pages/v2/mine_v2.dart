import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/viewmodels/game_selection_view_model.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/platforms/platform_descriptor.dart';

class MinePageV2 extends ConsumerWidget {
  const MinePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameSelectionViewModelProvider);
    final accountState = ref.watch(accountViewModelProvider);
    final selectedGame = gameState.selectedGame;

    if (gameState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profilePages = selectedGame?.descriptor.profilePages ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 24,
        title: const Text('我的'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 账号管理区域
          _buildAccountSection(context, ref, accountState),
          const Divider(height: 1),
          // 游戏个人页面
          Expanded(
            child: profilePages.isEmpty
                ? _buildEmptyState(context)
                : profilePages.length == 1
                    ? profilePages[0].builder(context)
                    : _buildTabView(context, profilePages),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    WidgetRef ref,
    AccountState accountState,
  ) {
    final currentAccount = accountState.currentAccount;
    final compatibleAccounts = accountState.accountsForCurrentGame;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '当前账号',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: () => _showAccountAddSheet(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('添加账号'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (currentAccount == null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text('未登录'),
                subtitle: const Text('点击添加账号'),
                trailing: const Icon(Icons.add),
                onTap: () => _showAccountAddSheet(context, ref),
              ),
            )
          else
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(currentAccount.resolvedDisplayName ?? '账号'),
                subtitle: Text(currentAccount.platformId),
                trailing: compatibleAccounts.length > 1
                  ? const Icon(Icons.swap_horiz)
                  : null,
                onTap: compatibleAccounts.length > 1
                    ? () => _showAccountSwitcher(context, ref, compatibleAccounts)
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  void _showAccountSwitcher(
    BuildContext context,
    WidgetRef ref,
    List<Account> accounts,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(account.resolvedDisplayName ?? '账号'),
            subtitle: Text(account.platformId),
            onTap: () {
              final identifier = _resolveAccountIdentifier(account);
              ref
                  .read(accountViewModelProvider.notifier)
                  .switchAccount(account, identifier);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Future<void> _showAccountAddSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final game = ref.read(gameSelectionViewModelProvider).selectedGame;
    if (game == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择游戏')),
      );
      return;
    }

    final platforms = CoreProvider.instance.getPlatformsForGame(game.id.value);
    final loginPlatforms =
        platforms.where((platform) => platform.loginHandler != null).toList();

    if (loginPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前游戏暂无可用的登录平台')),
      );
      return;
    }

    final selectedPlatform = await showModalBottomSheet<PlatformDescriptor>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView.separated(
          itemCount: loginPlatforms.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final platform = loginPlatforms[index];
            return ListTile(
              leading: platform.iconUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(platform.iconUrl!),
                    )
                  : Icon(platform.iconData ?? Icons.account_circle_outlined),
              title: Text(platform.name),
              subtitle: Text(platform.description),
              onTap: () => Navigator.pop(context, platform),
            );
          },
        ),
      ),
    );

    if (!context.mounted) return;
    if (selectedPlatform == null) return;

    final handler = selectedPlatform.loginHandler!;
    try {
      final result = await handler.showLoginPage(context);
      if (result == null) return;

      var effectiveResult = result;
      if (result.displayName == null ||
          result.avatarUrl == null ||
          result.externalId.isEmpty) {
        final info = await handler.fetchAccountInfo(result.credentialData);
        if (info != null) {
          effectiveResult = PlatformLoginResult(
            externalId:
                result.externalId.isNotEmpty ? result.externalId : info.externalId,
            credentialData: result.credentialData,
            displayName: result.displayName ?? info.displayName,
            avatarUrl: result.avatarUrl ?? info.avatarUrl,
            metadata: result.metadata ?? info.metadata,
          );
        }
      }

      await ref
          .read(accountViewModelProvider.notifier)
          .bindLoginResult(handler.platformId, effectiveResult);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('账号已添加')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('登录失败: $e')));
    }
  }

  String _resolveAccountIdentifier(Account account) {
    return account.externalId ??
        account.username ??
        account.platformId;
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 20),
          Text(
            '暂无个人信息',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView(BuildContext context, List<PageDescriptor> pages) {
    return DefaultTabController(
      length: pages.length,
      child: Column(
        children: [
          TabBar(
            tabs: pages
                .map(
                  (page) => Tab(
                    text: page.title,
                    icon: Icon(page.icon),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: pages.map((page) => page.builder(context)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
