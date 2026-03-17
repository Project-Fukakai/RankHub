import 'package:flutter/foundation.dart';

/// Kaleidxscope 进度状态
@immutable
class KaleidxscopeState {
  /// Key: title (天际线名称), Value: 已完成的 songId 集合
  final Map<String, Set<int>> progress;
  final bool isLoading;

  const KaleidxscopeState({
    this.progress = const {},
    this.isLoading = false,
  });

  KaleidxscopeState copyWith({
    Map<String, Set<int>>? progress,
    bool? isLoading,
  }) {
    return KaleidxscopeState(
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// 检查歌曲是否已完成
  bool isCompleted(String title, int songId) {
    return progress[title]?.contains(songId) ?? false;
  }

  /// 获取已完成数量
  int getCompletedCount(String title) {
    return progress[title]?.length ?? 0;
  }

  /// 获取总进度
  double getProgress(String title, List<int> totalSongIds) {
    if (totalSongIds.isEmpty) return 0;
    final completed = progress[title]?.where((id) => totalSongIds.contains(id)).length ?? 0;
    return completed / totalSongIds.length;
  }
}
