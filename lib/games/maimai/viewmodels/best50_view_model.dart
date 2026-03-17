import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_best50_data.dart';

/// Best 50 状态
class Best50State {
  final bool isLoading;
  final String? errorMessage;
  final List<MaimaiScore> dxScores;
  final List<MaimaiScore> standardScores;
  final int dxTotal;
  final int standardTotal;

  const Best50State({
    this.isLoading = false,
    this.errorMessage,
    this.dxScores = const [],
    this.standardScores = const [],
    this.dxTotal = 0,
    this.standardTotal = 0,
  });

  Best50State copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MaimaiScore>? dxScores,
    List<MaimaiScore>? standardScores,
    int? dxTotal,
    int? standardTotal,
  }) {
    return Best50State(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dxScores: dxScores ?? this.dxScores,
      standardScores: standardScores ?? this.standardScores,
      dxTotal: dxTotal ?? this.dxTotal,
      standardTotal: standardTotal ?? this.standardTotal,
    );
  }

  int get totalRating => dxTotal + standardTotal;

  /// 计算评分统计
  Map<String, double> calculateStats(List<MaimaiScore> scores) {
    if (scores.isEmpty) {
      return {'min': 0, 'avg': 0, 'max': 0};
    }

    final ratings = scores.map((s) => s.dxRating.toDouble()).toList();
    final min = ratings.reduce((a, b) => a < b ? a : b);
    final max = ratings.reduce((a, b) => a > b ? a : b);
    final avg = ratings.reduce((a, b) => a + b) / ratings.length;

    return {'min': min, 'avg': avg, 'max': max};
  }
}

/// Best 50 ViewModel
class Best50ViewModel extends Notifier<Best50State> {
  @override
  Best50State build() {
    // 监听账号变化
    ref.listen(accountViewModelProvider, (previous, next) {
      if (previous?.currentAccount != next.currentAccount) {
        loadBest50();
      }
    });

    // 自动加载数据
    Future.microtask(() => loadBest50());

    return const Best50State(isLoading: true);
  }

  /// 加载 Best 50 数据
  Future<void> loadBest50() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 确保账号已登录
      final accountState = ref.read(accountViewModelProvider);
      if (accountState.currentAccount == null) {
        throw Exception('未找到当前账号，请先登录');
      }

      final data = await ref.read(
        resourceProviderOf<MaimaiBest50Data>(maimaiBest50ResourceKey).future,
      );

      state = state.copyWith(
        dxScores: data.dxScores,
        standardScores: data.standardScores,
        dxTotal: data.dxTotal,
        standardTotal: data.standardTotal,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

/// Provider for Best50ViewModel
final best50ViewModelProvider = NotifierProvider<Best50ViewModel, Best50State>(
  () => Best50ViewModel(),
);
