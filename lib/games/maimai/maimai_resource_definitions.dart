import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/core/data_definition.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/core/resource_scope.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_best50_data.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/maimai_song_catalog.dart';
import 'package:rank_hub/games/maimai/models/net_score.dart';
import 'package:rank_hub/games/maimai/services/divingfish_api_service.dart';
import 'package:rank_hub/games/maimai/services/divingfish_maimai_mapper.dart';
import 'package:rank_hub/games/maimai/services/lxns_api_service.dart';
import 'package:rank_hub/games/maimai/services/maimai_isar_service.dart';
import 'package:rank_hub/games/maimai/services/maimai_net_api_service.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';

const PlatformId _lxnsPlatformId = PlatformId('lxns');
const PlatformId _divingfishPlatformId = PlatformId('divingfish');
const List<PlatformId> _lxnsOnly = [_lxnsPlatformId];
const List<PlatformId> _maimaiAccountPlatforms = [
  _lxnsPlatformId,
  _divingfishPlatformId,
];

const List<GameResourceDefinition> maimaiResourceDefinitions = [
  MaimaiSongCatalogResourceDefinition(),
  MaimaiSongListResourceDefinition(),
  MaimaiVersionListResourceDefinition(),
  MaimaiGenreListResourceDefinition(),
  MaimaiAliasMapResourceDefinition(),
  MaimaiCollectionListResourceDefinition(),
  MaimaiCollectionGenreListResourceDefinition(),
  MaimaiScoreListResourceDefinition(),
  MaimaiPlayerResourceDefinition(),
  MaimaiBest50ResourceDefinition(),
  MaimaiScoreHistoryResourceDefinition(),
  MaimaiNetUserPreviewResourceDefinition(),
  MaimaiNetUserScoresResourceDefinition(),
];

Future<String> _requireAccessToken(Account? account) async {
  if (account == null) {
    throw Exception('需要登录账号才能获取数据');
  }

  final provider = CoreProvider.instance.getCredentialProvider(
    account.platformId,
  );

  final effectiveAccount = provider != null
      ? await provider.getCredential(account)
      : account;

  final accessToken = effectiveAccount.accessToken;
  if (accessToken == null || accessToken.isEmpty) {
    throw Exception('访问令牌缺失或已失效，请重新登录');
  }

  return accessToken;
}

bool _isDivingFishAccount(Account? account) {
  return account != null && account.platformId == 'divingfish';
}

Future<List<MaimaiScore>> _fetchDivingFishScores(Account account) async {
  final result = await MaimaiDivingFishApiService.instance.getPlayerRecords(
    account: account,
  );

  final songs = await MaimaiIsarService.instance.getAllSongs();
  final songMap = {for (final song in songs) song.songId: song};

  final scores =
      result.scores
          .map(
            (score) => DivingFishMaimaiMapper.toMaimaiScore(
              score,
              song: songMap[score.songId],
            ),
          )
          .toList()
        ..sort((a, b) => b.dxRating.compareTo(a.dxRating));

  await MaimaiIsarService.instance.saveScores(scores);
  final player = DivingFishMaimaiMapper.toMaimaiPlayer(result.playerData);
  await MaimaiIsarService.instance.savePlayer(player);

  return scores;
}

class MaimaiSongCatalogResourceDefinition
    extends GameResourceDefinition<MaimaiSongCatalog> {
  const MaimaiSongCatalogResourceDefinition();

  @override
  ResourceKey<MaimaiSongCatalog> get key => maimaiSongCatalogResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  Future<MaimaiSongCatalog> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    await LxnsApiService.instance.syncSongsToDatabase(includeNotes: true);
    return _loadCatalogFromCache();
  }

  @override
  Future<MaimaiSongCatalog?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    final catalog = _loadCatalogFromCache(allowEmpty: true);
    if (catalog.songs.isEmpty) {
      return null;
    }
    return catalog;
  }

  @override
  Future<void> persist(MaimaiSongCatalog data) async {
    final isar = MaimaiIsarService.instance;
    await isar.saveSongs(data.songs);
    await isar.saveVersions(data.versions);
    await isar.saveGenres(data.genres);
    await isar.saveAliases(
      data.aliases.entries
          .map((entry) => Alias(songId: entry.key, aliases: entry.value))
          .toList(),
    );
  }

  MaimaiSongCatalog _loadCatalogFromCache({bool allowEmpty = true}) {
    final isar = MaimaiIsarService.instance;
    final songs = isar.getAllSongsSyncOrNull();
    final versions = isar.getAllVersionsSyncOrNull();
    final genres = isar.getAllGenresSyncOrNull();
    final aliases = isar.getAliasMapSyncOrNull();

    return MaimaiSongCatalog(
      songs: songs ?? const [],
      versions: versions ?? const [],
      genres: genres ?? const [],
      aliases: aliases ?? const {},
    );
  }
}

class MaimaiSongListResourceDefinition
    extends GameResourceDefinition<List<MaimaiSong>> {
  const MaimaiSongListResourceDefinition();

  @override
  ResourceKey<List<MaimaiSong>> get key => maimaiSongListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  List<ResourceKey> get dependencies => const [];

  @override
  Future<List<MaimaiSong>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final isar = MaimaiIsarService.instance;
    return await isar.getAllSongs();
  }

  @override
  Future<List<MaimaiSong>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return MaimaiIsarService.instance.getAllSongsSyncOrNull();
  }

  @override
  Future<void> persist(List<MaimaiSong> data) async {
    await MaimaiIsarService.instance.saveSongs(data);
  }
}

class MaimaiVersionListResourceDefinition
    extends GameResourceDefinition<List<MaimaiVersion>> {
  const MaimaiVersionListResourceDefinition();

  @override
  ResourceKey<List<MaimaiVersion>> get key => maimaiVersionListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  List<ResourceKey> get dependencies => const [];

  @override
  Future<List<MaimaiVersion>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final versions = await MaimaiIsarService.instance.getAllVersions();
    versions.sort((a, b) => b.version.compareTo(a.version));
    return versions;
  }

  @override
  Future<List<MaimaiVersion>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    final versions = MaimaiIsarService.instance.getAllVersionsSyncOrNull();
    versions?.sort((a, b) => b.version.compareTo(a.version));
    return versions;
  }

  @override
  Future<void> persist(List<MaimaiVersion> data) async {
    await MaimaiIsarService.instance.saveVersions(data);
  }
}

class MaimaiGenreListResourceDefinition
    extends GameResourceDefinition<List<MaimaiGenre>> {
  const MaimaiGenreListResourceDefinition();

  @override
  ResourceKey<List<MaimaiGenre>> get key => maimaiGenreListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  List<ResourceKey> get dependencies => const [];

  @override
  Future<List<MaimaiGenre>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    return await MaimaiIsarService.instance.getAllGenres();
  }

  @override
  Future<List<MaimaiGenre>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return MaimaiIsarService.instance.getAllGenresSyncOrNull();
  }

  @override
  Future<void> persist(List<MaimaiGenre> data) async {
    await MaimaiIsarService.instance.saveGenres(data);
  }
}

class MaimaiAliasMapResourceDefinition
    extends GameResourceDefinition<Map<int, List<String>>> {
  const MaimaiAliasMapResourceDefinition();

  @override
  ResourceKey<Map<int, List<String>>> get key => maimaiAliasMapResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  List<ResourceKey> get dependencies => const [];

  @override
  Future<Map<int, List<String>>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    return await MaimaiIsarService.instance.getAliasMap();
  }

  @override
  Future<Map<int, List<String>>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return MaimaiIsarService.instance.getAliasMapSyncOrNull();
  }

  @override
  Future<void> persist(Map<int, List<String>> data) async {
    await MaimaiIsarService.instance.saveAliases(
      data.entries
          .map((entry) => Alias(songId: entry.key, aliases: entry.value))
          .toList(),
    );
  }
}

class MaimaiCollectionListResourceDefinition
    extends GameResourceDefinition<List<MaimaiCollection>> {
  const MaimaiCollectionListResourceDefinition();

  @override
  ResourceKey<List<MaimaiCollection>> get key =>
      maimaiCollectionListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  Future<List<MaimaiCollection>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    await LxnsApiService.instance.syncCollectionsToDatabase(
      includeRequired: true,
    );
    return await MaimaiIsarService.instance.getAllCollections();
  }

  @override
  Future<List<MaimaiCollection>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return MaimaiIsarService.instance.getAllCollectionsSyncOrNull();
  }

  @override
  Future<void> persist(List<MaimaiCollection> data) async {
    await MaimaiIsarService.instance.saveCollections(data);
  }
}

class MaimaiCollectionGenreListResourceDefinition
    extends GameResourceDefinition<List<MaimaiCollectionGenre>> {
  const MaimaiCollectionGenreListResourceDefinition();

  @override
  ResourceKey<List<MaimaiCollectionGenre>> get key =>
      maimaiCollectionGenreListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  List<ResourceKey> get dependencies => [maimaiCollectionListResourceKey];

  @override
  Future<List<MaimaiCollectionGenre>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    return await MaimaiIsarService.instance.getAllCollectionGenres();
  }

  @override
  Future<List<MaimaiCollectionGenre>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return MaimaiIsarService.instance.getAllCollectionGenresSyncOrNull();
  }

  @override
  Future<void> persist(List<MaimaiCollectionGenre> data) async {
    await MaimaiIsarService.instance.saveCollectionGenres(data);
  }
}

class MaimaiScoreListResourceDefinition
    extends GameResourceDefinition<List<MaimaiScore>> {
  const MaimaiScoreListResourceDefinition();

  @override
  ResourceKey<List<MaimaiScore>> get key => maimaiScoreListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _maimaiAccountPlatforms;

  @override
  Duration? get ttl => const Duration(hours: 1);

  @override
  bool get forceRefreshWhenTriggered => true;

  @override
  bool get accountRelated => true;

  @override
  Future<List<MaimaiScore>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    if (account == null) {
      throw Exception('需要登录账号才能获取数据');
    }

    if (_isDivingFishAccount(account)) {
      return await _fetchDivingFishScores(account);
    }

    final accessToken = await _requireAccessToken(account);
    await LxnsApiService.instance.syncPlayerScoresToDatabase(
      accessToken: accessToken,
    );
    return await MaimaiIsarService.instance.getAllScoresSortedByRating();
  }

  @override
  Future<List<MaimaiScore>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async =>
      null;

  @override
  Future<void> persist(List<MaimaiScore> data) async {
    await MaimaiIsarService.instance.saveScores(data);
  }
}

class MaimaiPlayerResourceDefinition
    extends GameResourceDefinition<MaimaiPlayer> {
  const MaimaiPlayerResourceDefinition();

  @override
  ResourceKey<MaimaiPlayer> get key => maimaiPlayerResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _maimaiAccountPlatforms;

  @override
  Duration? get ttl => const Duration(hours: 1);

  @override
  bool get forceRefreshWhenTriggered => true;

  @override
  bool get accountRelated => true;

  @override
  Future<MaimaiPlayer> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    if (account == null) {
      throw Exception('需要登录账号才能获取数据');
    }

    if (_isDivingFishAccount(account)) {
      final result = await MaimaiDivingFishApiService.instance.getPlayerRecords(
        account: account,
      );
      final player = DivingFishMaimaiMapper.toMaimaiPlayer(result.playerData);
      await MaimaiIsarService.instance.savePlayer(player);
      return player;
    }

    final accessToken = await _requireAccessToken(account);
    final player = await LxnsApiService.instance.getPlayerInfo(
      accessToken: accessToken,
    );
    await MaimaiIsarService.instance.savePlayer(player);
    return player;
  }

  @override
  Future<MaimaiPlayer?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async =>
      null;

  @override
  Future<void> persist(MaimaiPlayer data) async {
    await MaimaiIsarService.instance.savePlayer(data);
  }
}

class MaimaiBest50ResourceDefinition
    extends GameResourceDefinition<MaimaiBest50Data> {
  const MaimaiBest50ResourceDefinition();

  @override
  ResourceKey<MaimaiBest50Data> get key => maimaiBest50ResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _maimaiAccountPlatforms;

  @override
  Duration? get ttl => const Duration(hours: 1);

  @override
  bool get forceRefreshWhenTriggered => true;

  @override
  bool get accountRelated => true;

  @override
  Future<MaimaiBest50Data> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    if (account == null) {
      throw Exception('需要登录账号才能获取数据');
    }

    if (_isDivingFishAccount(account)) {
      final scores = await _fetchDivingFishScores(account);
      return DivingFishMaimaiMapper.buildBest50(scores);
    }

    final accessToken = await _requireAccessToken(account);
    final data = await LxnsApiService.instance.getPlayerBest50(
      accessToken: accessToken,
    );

    final dxList = data['dx'] as List;
    final standardList = data['standard'] as List;

    return MaimaiBest50Data(
      dxScores: dxList
          .map((e) => MaimaiScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      standardScores: standardList
          .map((e) => MaimaiScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      dxTotal: data['dx_total'] as int,
      standardTotal: data['standard_total'] as int,
    );
  }

  @override
  Future<MaimaiBest50Data?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async =>
      null;

  @override
  Future<void> persist(MaimaiBest50Data data) async {}
}

class MaimaiScoreHistoryResourceDefinition
    extends GameResourceDefinition<List<Map<String, dynamic>>> {
  const MaimaiScoreHistoryResourceDefinition();

  @override
  ResourceKey<List<Map<String, dynamic>>> get key =>
      maimaiScoreHistoryResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(hours: 1);

  @override
  bool get forceRefreshWhenTriggered => true;

  @override
  bool get accountRelated => true;

  @override
  Future<List<Map<String, dynamic>>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    if (_isDivingFishAccount(account)) {
      throw Exception('当前平台不支持谱面历史成绩');
    }

    final accessToken = await _requireAccessToken(account);
    final params = _parseScoreHistoryScope(key.scope);

    return await LxnsApiService.instance.getScoreHistory(
      accessToken: accessToken,
      songId: params.songId,
      levelIndex: params.levelIndex,
      songType: params.songType,
    );
  }

  @override
  Future<List<Map<String, dynamic>>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async =>
      null;

  @override
  Future<void> persist(List<Map<String, dynamic>> data) async {}
}

class MaimaiNetUserPreviewResourceDefinition
    extends GameResourceDefinition<UserPreview> {
  const MaimaiNetUserPreviewResourceDefinition();

  @override
  ResourceKey<UserPreview> get key => maimaiNetUserPreviewResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => true;

  @override
  Future<UserPreview> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final qrCode = _decodeScope(key.scope, 'QR Code');
    return await MaimaiNetApiService.instance.getUserPreview(qrCode);
  }

  @override
  Future<UserPreview?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async =>
      null;

  @override
  Future<void> persist(UserPreview data) async {}
}

class MaimaiNetUserScoresResourceDefinition
    extends GameResourceDefinition<List<NetScore>> {
  const MaimaiNetUserScoresResourceDefinition();

  @override
  ResourceKey<List<NetScore>> get key => maimaiNetUserScoresResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _lxnsOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => true;

  @override
  Future<List<NetScore>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final qrCode = _decodeScope(key.scope, 'QR Code');
    final session = MaimaiNetApiService.instance.createSessionFromQrCode(
      qrCode,
    );

    try {
      await MaimaiNetApiService.instance.initAndLogin(session);
      return await MaimaiNetApiService.instance.getAllUserScores(session);
    } finally {
      if (session.isLoggedIn) {
        try {
          await MaimaiNetApiService.instance.logout(session);
        } catch (_) {
          // ignore
        }
      }
    }
  }

  @override
  Future<List<NetScore>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async =>
      null;

  @override
  Future<void> persist(List<NetScore> data) async {}
}

class _ScoreHistoryParams {
  final int songId;
  final int levelIndex;
  final String songType;

  const _ScoreHistoryParams({
    required this.songId,
    required this.levelIndex,
    required this.songType,
  });
}

_ScoreHistoryParams _parseScoreHistoryScope(String? scope) {
  if (scope == null || scope.isEmpty) {
    throw Exception('缺少谱面历史成绩参数');
  }

  final parts = scope.split('&');
  final values = <String, String>{};
  for (final part in parts) {
    final entry = part.split('=');
    if (entry.length == 2) {
      values[entry[0]] = Uri.decodeComponent(entry[1]);
    }
  }

  final songId = int.tryParse(values['songId'] ?? '');
  final levelIndex = int.tryParse(values['levelIndex'] ?? '');
  final songType = values['songType'];

  if (songId == null || levelIndex == null || songType == null) {
    throw Exception('谱面历史成绩参数无效');
  }

  return _ScoreHistoryParams(
    songId: songId,
    levelIndex: levelIndex,
    songType: songType,
  );
}

String _decodeScope(String? scope, String label) {
  if (scope == null || scope.isEmpty) {
    throw Exception('缺少 $label');
  }
  return Uri.decodeComponent(scope);
}
