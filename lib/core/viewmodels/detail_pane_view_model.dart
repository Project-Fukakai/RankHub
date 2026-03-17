import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data class for difficulty detail page
class DifficultyDetailData {
  final dynamic difficulty;
  final String songName;
  final int songId;

  const DifficultyDetailData({
    required this.difficulty,
    required this.songName,
    required this.songId,
  });
}

/// Detail page entry in the navigation stack
class DetailPageEntry {
  final String route;
  final Object? extraData;

  const DetailPageEntry({
    required this.route,
    this.extraData,
  });
}

/// Detail pane state for three-column tablet layout with navigation stack
class DetailPaneState {
  final List<DetailPageEntry> stack;

  const DetailPaneState({
    this.stack = const [],
  });

  bool get isVisible => stack.isNotEmpty;

  DetailPageEntry? get currentPage => stack.isEmpty ? null : stack.last;

  bool get canPop => stack.length > 1;

  DetailPaneState copyWith({
    List<DetailPageEntry>? stack,
  }) {
    return DetailPaneState(
      stack: stack ?? this.stack,
    );
  }
}

/// View model for managing detail pane state with navigation stack
class DetailPaneViewModel extends Notifier<DetailPaneState> {
  @override
  DetailPaneState build() {
    return const DetailPaneState();
  }

  /// Show detail in the detail pane (replaces entire stack)
  void showDetail(String route, Object? extra) {
    state = DetailPaneState(
      stack: [DetailPageEntry(route: route, extraData: extra)],
    );
  }

  /// Push a new detail page onto the stack
  void pushDetail(String route, Object? extra) {
    final newStack = [...state.stack, DetailPageEntry(route: route, extraData: extra)];
    state = DetailPaneState(stack: newStack);
  }

  /// Pop the current detail page from the stack
  void popDetail() {
    if (state.stack.length > 1) {
      final newStack = state.stack.sublist(0, state.stack.length - 1);
      state = DetailPaneState(stack: newStack);
    } else if (state.stack.length == 1) {
      // If only one page, hide the detail pane
      hideDetail();
    }
  }

  /// Hide detail pane (clear stack)
  void hideDetail() {
    state = const DetailPaneState();
  }

  /// Check if a route is a detail route
  bool isDetailRoute(String route) {
    const detailRoutes = [
      '/maimai/song',
      '/maimai/difficulty',
      '/maimai/collection',
      '/maimai/kaleidxscope',
      '/maimai/random',
      '/maimai/net-sync',
      '/phigros/song',
      '/phigros/b30-export',
    ];
    return detailRoutes.contains(route);
  }
}

final detailPaneViewModelProvider =
    NotifierProvider<DetailPaneViewModel, DetailPaneState>(
  () => DetailPaneViewModel(),
);
