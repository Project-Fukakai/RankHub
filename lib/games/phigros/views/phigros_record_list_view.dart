import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/games/phigros/viewmodels/phigros_view_model.dart';
import 'package:rank_hub/games/phigros/widgets/phigros_record_list_item.dart';

/// Phigros 成绩列表视图
class PhigrosRecordListView extends ConsumerStatefulWidget {
  const PhigrosRecordListView({super.key});

  @override
  ConsumerState<PhigrosRecordListView> createState() =>
      _PhigrosRecordListViewState();
}

class _PhigrosRecordListViewState
    extends ConsumerState<PhigrosRecordListView> {
  final TextEditingController _searchController = TextEditingController();
  String? _loadedAccountId;
  ProviderSubscription<AccountState>? _accountSubscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(phigrosViewModelProvider.notifier).loadSongs(),
    );

    _searchController.addListener(() {
      ref
          .read(phigrosViewModelProvider.notifier)
          .setRecordSearchKeyword(_searchController.text);
    });

    _accountSubscription = ref.listenManual<AccountState>(
      accountViewModelProvider,
      (previous, next) {
        final account = next.currentAccount;
        if (account == null) return;
        final accountId = extractPhigrosAccountIdentifier(account);
        if (_loadedAccountId == accountId) return;
        _loadedAccountId = accountId;

        Future.microtask(
          () => ref.read(phigrosViewModelProvider.notifier).loadRecords(),
        );
      },
    );

    final currentAccount = ref.read(accountViewModelProvider).currentAccount;
    if (currentAccount != null) {
      final accountId = extractPhigrosAccountIdentifier(currentAccount);
      _loadedAccountId = accountId;
      Future.microtask(
        () => ref.read(phigrosViewModelProvider.notifier).loadRecords(),
      );
    }
  }

  @override
  void dispose() {
    _accountSubscription?.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phigrosViewModelProvider);
    final viewModel = ref.read(phigrosViewModelProvider.notifier);
    final accountState = ref.watch(accountViewModelProvider);
    final account = accountState.currentAccount;
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> refresh() async {
      if (account == null) return;
      await viewModel.loadRecords(
        forceRefresh: true,
      );
    }

    return Stack(
      children: [
        if (state.isLoadingRecords)
          const Center(child: CircularProgressIndicator())
        else
          Builder(builder: (context) {
            if (state.filteredRecords.isEmpty) {
              return RefreshIndicator(
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
            }

            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 200),
                itemCount: state.filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = state.filteredRecords[index];
                  return PhigrosRecordListItem(record: record);
                },
              ),
            );
          }),

        // 搜索栏 - 浮在底部
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.8),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '搜索曲目...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: state.recordSearchKeyword.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
