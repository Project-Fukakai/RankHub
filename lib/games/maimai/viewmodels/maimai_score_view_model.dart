import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/states/maimai_score_state.dart';

/// Maimai 成绩 ViewModel
/// 管理成绩数据的加载和统计，依赖账号状态
class MaimaiScoreViewModel extends Notifier<MaimaiScoreState> {
  @override
  MaimaiScoreState build() {
    // 监听账号变化
    ref.listen(accountViewModelProvider, (previous, next) {
      if (previous?.currentAccount != next.currentAccount) {
        loadScores();
      }
    });

    // 自动加载数据
    Future.microtask(() => loadScores());

    return const MaimaiScoreState();
  }

  /// 加载成绩数据
  /// [forceRefresh] 是否强制从 API 刷新
  Future<void> loadScores({bool forceRefresh = false}) async {
    final accountState = ref.read(accountViewModelProvider);
    final account = accountState.currentAccount;

    if (account == null) {
      CoreLogService.w(
        '未找到当前账号，无法加载成绩',
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
      '开始加载成绩数据 (forceRefresh: $forceRefresh)',
      scope: 'MAIMAI',
      platform: 'LXNS',
    );
    final displayName = account.resolvedDisplayName ?? 'Unknown';
    CoreLogService.i(
      '使用账号: $displayName',
      scope: 'MAIMAI',
      platform: 'LXNS',
    );

    state = state.copyWith(
      loadStatus: forceRefresh
          ? DataLoadStatus.loadingFromApi
          : DataLoadStatus.loadingFromDb,
      errorMessage: null,
    );

    try {
      if (forceRefresh) {
        await ref.read(
          refreshResourceProviderOf<List<MaimaiScore>>(
            maimaiScoreListResourceKey,
          ).future,
        );
      }

      final scores = await ref.read(
        resourceProviderOf<List<MaimaiScore>>(maimaiScoreListResourceKey).future,
      );

      CoreLogService.i(
        '加载到 ${scores.length} 条成绩',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );

      // 计算统计数据
      final best50 = MaimaiScoreState.calculateBest50(scores);
      final fcStats = MaimaiScoreState.calculateFcStats(scores);
      final fsStats = MaimaiScoreState.calculateFsStats(scores);

      state = state.copyWith(
        allScores: scores,
        best50Scores: best50,
        fcStats: fcStats,
        fsStats: fsStats,
        loadStatus: DataLoadStatus.success,
        isFromCache: !forceRefresh,
      );

      CoreLogService.i(
        '成绩加载完成',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
    } catch (e) {
      CoreLogService.e(
        '加载成绩失败: $e',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );

      String errorMsg = '加载成绩失败: $e';
      if (e.toString().contains('token') || e.toString().contains('401')) {
        errorMsg = '访问令牌已过期，请重新登录';
      } else if (e.toString().contains('404')) {
        errorMsg = '玩家档案不存在，请前往落雪咖啡屋官网同步一次数据来创建玩家档案';
      } else if (e.toString().contains('network') ||
          e.toString().contains('timeout')) {
        errorMsg = '网络连接失败，请检查网络';
      }

      state = state.copyWith(
        loadStatus: DataLoadStatus.error,
        errorMessage: errorMsg,
      );
    }
  }

  /// 获取 Best 50 成绩
  List<dynamic> getBest50Scores() => state.best50Scores;

  /// 根据曲目 ID 获取成绩
  List<dynamic> getScoresBySongId(int songId) {
    return state.getScoresBySongId(songId);
  }

  /// 获取指定难度以上的成绩
  List<dynamic> getScoresByMinLevel(double minLevel) {
    return state.getScoresByMinLevel(minLevel);
  }

  /// 获取指定评级的成绩
  List<dynamic> getScoresByRate(String rateType) {
    return state.getScoresByRate(rateType);
  }

  /// 获取 FC/AP 统计
  Map<String, int> getFcStats() => state.fcStats;

  /// 获取 FS 统计
  Map<String, int> getFsStats() => state.fsStats;
}

/// Provider for MaimaiScoreViewModel
final maimaiScoreViewModelProvider =
    NotifierProvider<MaimaiScoreViewModel, MaimaiScoreState>(
      () => MaimaiScoreViewModel(),
    );
