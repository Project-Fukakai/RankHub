import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/core/repositories/game_repository.dart';

/// 游戏选择状态
class GameSelectionState {
  final Game? selectedGame;
  final List<Game> availableGames;
  final bool isLoading;

  const GameSelectionState({
    this.selectedGame,
    this.availableGames = const [],
    this.isLoading = false,
  });

  GameSelectionState copyWith({
    Game? selectedGame,
    List<Game>? availableGames,
    bool? isLoading,
  }) {
    return GameSelectionState(
      selectedGame: selectedGame ?? this.selectedGame,
      availableGames: availableGames ?? this.availableGames,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 游戏选择 ViewModel
/// 管理全局游戏选择（不再区分 Wiki/Rank）
class GameSelectionViewModel extends Notifier<GameSelectionState> {
  late final GameRepository _repository;

  @override
  GameSelectionState build() {
    _repository = GameRepository(
      gameRegistry: CoreProvider.instance.gameRegistry,
    );

    // 异步初始化
    Future.microtask(() => _initialize());

    return const GameSelectionState(isLoading: true);
  }

  Future<void> _initialize() async {
    final games = _repository.getAllGames();
    final lastGame = await _repository.loadLastSelectedGame();
    final selected = lastGame ?? (games.isNotEmpty ? games.first : null);

    state = GameSelectionState(
      selectedGame: selected,
      availableGames: games,
      isLoading: false,
    );

    if (selected != null) {
      // 初始化时同步构建 AppContext，避免需要手动选择游戏
      await CoreProvider.instance.setCurrentGame(selected, ref);
    }
  }

  /// 选择游戏
  Future<void> selectGame(Game game) async {
    state = state.copyWith(selectedGame: game);
    await _repository.saveSelectedGameId(game.id.value);

    // 通知 CoreProvider 更新上下文
    await CoreProvider.instance.setCurrentGame(game, ref);
  }

  /// 刷新游戏列表
  void refreshGames() {
    final games = _repository.getAllGames();
    state = state.copyWith(availableGames: games);
  }
}

final gameSelectionViewModelProvider =
    NotifierProvider<GameSelectionViewModel, GameSelectionState>(
  () => GameSelectionViewModel(),
);
