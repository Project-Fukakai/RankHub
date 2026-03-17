import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 天际线进度 ViewModel
class KaleidxscopeProgressViewModel extends Notifier<Map<String, Set<int>>> {
  static const String _storageKeyPrefix = 'kaleidxscope_progress_v2_';

  @override
  Map<String, Set<int>> build() {
    // 初始状态为空，并在后台加载数据
    Future.microtask(() => _loadProgress());
    return {};
  }

  /// 加载所有进度
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith(_storageKeyPrefix));

    final newProgress = <String, Set<int>>{};

    for (final key in keys) {
      final String title = key.substring(_storageKeyPrefix.length);
      final List<String>? completedIds = prefs.getStringList(key);
      if (completedIds != null) {
        newProgress[title] = completedIds.map((e) => int.parse(e)).toSet();
      }
    }

    state = newProgress;
  }

  /// 检查歌曲是否已完成
  bool isCompleted(String title, int songId) {
    return state[title]?.contains(songId) ?? false;
  }

  /// 切换完成状态
  Future<void> toggleCompletion(String title, int songId) async {
    final currentMap = Map<String, Set<int>>.from(state);
    final currentSet = Set<int>.from(currentMap[title] ?? {});

    if (currentSet.contains(songId)) {
      currentSet.remove(songId);
    } else {
      currentSet.add(songId);
    }

    currentMap[title] = currentSet;
    state = currentMap;

    // 持久化
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      '$_storageKeyPrefix$title',
      currentSet.map((e) => e.toString()).toList(),
    );
  }

  /// 获取已完成数量
  int getCompletedCount(String title) {
    return state[title]?.length ?? 0;
  }

  /// 获取总进度
  double getProgress(String title, List<int> totalSongIds) {
    if (totalSongIds.isEmpty) return 0;
    final completed =
        state[title]?.where((id) => totalSongIds.contains(id)).length ?? 0;
    return completed / totalSongIds.length;
  }
}

final kaleidxscopeProgressProvider =
    NotifierProvider<KaleidxscopeProgressViewModel, Map<String, Set<int>>>(
      () => KaleidxscopeProgressViewModel(),
    );
