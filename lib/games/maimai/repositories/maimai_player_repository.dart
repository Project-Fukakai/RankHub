import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';
import 'package:rank_hub/platforms/maimai/lxns_credential_provider.dart';

/// Maimai 玩家数据仓库
/// 封装玩家信息相关的数据访问逻辑
class MaimaiPlayerRepository {
  final MaimaiIsarService _isarService;
  final LxnsApiService _apiService;

  MaimaiPlayerRepository({
    MaimaiIsarService? isarService,
    LxnsApiService? apiService,
  }) : _isarService = isarService ?? MaimaiIsarService.instance,
       _apiService = apiService ?? LxnsApiService.instance;

  /// 获取玩家信息
  /// [account] 当前账号
  /// [forceRefresh] 是否强制从 API 刷新
  Future<MaimaiPlayer?> getPlayerInfo({
    required Account account,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      return await _fetchPlayerFromApi(account);
    }

    // 尝试从数据库加载
    final players = await _isarService.getAllPlayers();
    if (players.isNotEmpty) {
      return players.first;
    }

    // 数据库无数据，从 API 加载
    return await _fetchPlayerFromApi(account);
  }

  /// 根据好友码获取玩家
  Future<MaimaiPlayer?> getPlayerByFriendCode(int friendCode) async {
    return await _isarService.getPlayerByFriendCode(friendCode);
  }

  /// 获取所有玩家
  Future<List<MaimaiPlayer>> getAllPlayers() async {
    return await _isarService.getAllPlayers();
  }

  /// 保存玩家信息
  Future<void> savePlayer(MaimaiPlayer player) async {
    await _isarService.savePlayer(player);
  }

  /// 从 API 获取玩家信息
  Future<MaimaiPlayer> _fetchPlayerFromApi(Account account) async {
    final credentialProvider = LxnsCredentialProvider();
    final accountWithValidToken = await credentialProvider.getCredential(account);
    final accessToken = accountWithValidToken.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('账号未授权或令牌已失效，请重新登录');
    }

    final player = await _apiService.getPlayerInfo(accessToken: accessToken);
    await _isarService.savePlayer(player);
    return player;
  }

  /// 获取 Rating 趋势
  Future<List<MaimaiRatingTrend>> getRatingTrends({
    required String startDate,
    required String endDate,
  }) async {
    return await _isarService.getRatingTrends(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// 保存 Rating 趋势
  Future<void> saveRatingTrend(MaimaiRatingTrend trend) async {
    await _isarService.saveRatingTrend(trend);
  }
}
