import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/states/maimai_player_state.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';

/// Maimai 玩家 ViewModel
/// 管理玩家信息和 Rating 趋势数据
class MaimaiPlayerViewModel extends Notifier<MaimaiPlayerState> {
  @override
  MaimaiPlayerState build() {
    // 监听账号变化
    ref.listen(accountViewModelProvider, (previous, next) {
      if (previous?.currentAccount != next.currentAccount) {
        loadPlayerInfo();
      }
    });

    // 自动加载数据
    Future.microtask(() => loadPlayerInfo());

    return const MaimaiPlayerState();
  }

  /// 加载玩家信息
  /// [forceRefresh] 是否强制从 API 刷新
  Future<void> loadPlayerInfo({bool forceRefresh = false}) async {
    final accountState = ref.read(accountViewModelProvider);
    final account = accountState.currentAccount;

    if (account == null) {
      CoreLogService.w(
        '未找到当前账号，无法加载玩家信息',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
      state = state.copyWith(
        loadStatus: DataLoadStatus.error,
        errorMessage: '请先登录账号',
      );
      return;
    }

    CoreLogService.i(
      '开始加载玩家信息 (forceRefresh: $forceRefresh)',
      scope: 'MAIMAI',
      platform: 'LXNS',
    );

    state = state.copyWith(
      loadStatus: DataLoadStatus.loadingFromApi,
      errorMessage: null,
    );

    try {
      if (forceRefresh) {
        await ref.read(
          refreshResourceProviderOf<MaimaiPlayer>(maimaiPlayerResourceKey)
              .future,
        );
      }

      final player = await ref.read(
        resourceProviderOf<MaimaiPlayer>(maimaiPlayerResourceKey).future,
      );

      state = state.copyWith(
        player: player,
        loadStatus: DataLoadStatus.success,
      );

      CoreLogService.i(
        '玩家信息加载完成',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
    } catch (e) {
      CoreLogService.e(
        '加载玩家信息失败: $e',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );

      String errorMsg = '加载玩家信息失败: $e';
      if (e.toString().contains('token') || e.toString().contains('401')) {
        errorMsg = '访问令牌已过期，请重新登录';
      } else if (e.toString().contains('404')) {
        errorMsg = '玩家档案不存在，请前往落雪咖啡屋官网同步一次数据来创建玩家档案';
      }

      state = state.copyWith(
        loadStatus: DataLoadStatus.error,
        errorMessage: errorMsg,
      );
    }
  }

  /// 加载 Rating 趋势
  Future<void> loadRatingTrends({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final trends = await MaimaiIsarService.instance.getRatingTrends(
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(ratingTrends: trends);
    } catch (e) {
      CoreLogService.e(
        '加载 Rating 趋势失败: $e',
        scope: 'MAIMAI',
        platform: 'LOCAL',
      );
    }
  }
}

/// Provider for MaimaiPlayerViewModel
final maimaiPlayerViewModelProvider =
    NotifierProvider<MaimaiPlayerViewModel, MaimaiPlayerState>(
  () => MaimaiPlayerViewModel(),
);
