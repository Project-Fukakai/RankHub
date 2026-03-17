import 'package:rank_hub/core/game.dart';
import 'package:rank_hub/core/game_registry_provider.dart';
import 'package:rank_hub/core/services/storage_service.dart';

/// 游戏仓库
/// 封装游戏列表查询和选择持久化
class GameRepository {
  final GameRegistryProvider _gameRegistry;
  final CoreStorageService _storage;

  GameRepository({
    required GameRegistryProvider gameRegistry,
    CoreStorageService? storage,
  })  : _gameRegistry = gameRegistry,
        _storage = storage ?? CoreStorageService.instance;

  /// 获取所有已注册游戏
  List<Game> getAllGames() {
    return _gameRegistry.getAllGames();
  }

  /// 根据 ID 查找游戏
  Game? findById(String gameId) {
    return _gameRegistry.findByIdString(gameId);
  }

  /// 获取上次选择的游戏 ID
  Future<String?> getLastSelectedGameId() {
    return _storage.getLastSelectedGameId();
  }

  /// 保存选择的游戏 ID
  Future<void> saveSelectedGameId(String gameId) {
    return _storage.setLastSelectedGameId(gameId);
  }

  /// 加载上次选择的游戏，找不到则返回第一个
  Future<Game?> loadLastSelectedGame() async {
    final games = getAllGames();
    if (games.isEmpty) return null;

    final lastId = await getLastSelectedGameId();
    if (lastId != null) {
      final game = findById(lastId);
      if (game != null) return game;
    }

    return games.first;
  }
}
