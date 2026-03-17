import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/core/data_definition.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/core/resource_scope.dart';
import 'package:rank_hub/games/phigros/phigros_resources.dart';
import 'package:rank_hub/games/phigros/services/phigros_isar_service.dart';
import 'package:rank_hub/games/phigros/services/phigros_resource_api_service.dart';
import 'package:rank_hub/games/phigros/services/phigros_score_sync_service.dart';
import 'package:rank_hub/models/phigros/avatar.dart';
import 'package:rank_hub/models/phigros/collection.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/player_summary.dart';
import 'package:rank_hub/models/phigros/song.dart';

const PlatformId _phigrosPlatformId = PlatformId('phigros');
const List<PlatformId> _phigrosOnly = [_phigrosPlatformId];

const List<GameResourceDefinition> phigrosResourceDefinitions = [
  PhigrosSongListResourceDefinition(),
  PhigrosCollectionListResourceDefinition(),
  PhigrosAvatarListResourceDefinition(),
  PhigrosRecordListResourceDefinition(),
  PhigrosPlayerSummaryResourceDefinition(),
];

String _requireSessionToken(Account? account) {
  if (account == null) {
    throw Exception('需要登录账号才能获取数据');
  }

  final sessionToken = account.apiKey;
  if (sessionToken == null || sessionToken.isEmpty) {
    throw Exception('Session Token 缺失或已失效，请重新登录');
  }

  return sessionToken;
}

String _resolveAccountIdentifier(ResourceScope scope, Account account) {
  if (scope.accountIdentifier != null && scope.accountIdentifier!.isNotEmpty) {
    return scope.accountIdentifier!;
  }

  return account.externalId ?? account.username ?? account.platformId;
}

class PhigrosSongListResourceDefinition
    extends GameResourceDefinition<List<PhigrosSong>> {
  const PhigrosSongListResourceDefinition();

  @override
  ResourceKey<List<PhigrosSong>> get key => phigrosSongListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _phigrosOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  Future<List<PhigrosSong>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final songs = await PhigrosResourceApiService.instance.fetchSongs();
    await PhigrosIsarService.instance.saveSongs(songs);
    return songs;
  }

  @override
  Future<List<PhigrosSong>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return PhigrosIsarService.instance.getAllSongsSyncOrNull();
  }

  @override
  Future<void> persist(List<PhigrosSong> data) async {
    await PhigrosIsarService.instance.saveSongs(data);
  }
}

class PhigrosCollectionListResourceDefinition
    extends GameResourceDefinition<List<PhigrosCollection>> {
  const PhigrosCollectionListResourceDefinition();

  @override
  ResourceKey<List<PhigrosCollection>> get key =>
      phigrosCollectionListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _phigrosOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  Future<List<PhigrosCollection>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final collections =
        await PhigrosResourceApiService.instance.fetchCollections();
    await PhigrosIsarService.instance.saveCollections(collections);
    return collections;
  }

  @override
  Future<List<PhigrosCollection>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return PhigrosIsarService.instance.getAllCollectionsSyncOrNull();
  }

  @override
  Future<void> persist(List<PhigrosCollection> data) async {
    await PhigrosIsarService.instance.saveCollections(data);
  }
}

class PhigrosAvatarListResourceDefinition
    extends GameResourceDefinition<List<PhigrosAvatar>> {
  const PhigrosAvatarListResourceDefinition();

  @override
  ResourceKey<List<PhigrosAvatar>> get key => phigrosAvatarListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _phigrosOnly;

  @override
  Duration? get ttl => const Duration(days: 1);

  @override
  bool get forceRefreshWhenTriggered => false;

  @override
  Future<List<PhigrosAvatar>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    final avatars = await PhigrosResourceApiService.instance.fetchAvatars();
    await PhigrosIsarService.instance.saveAvatars(avatars);
    return avatars;
  }

  @override
  Future<List<PhigrosAvatar>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    return PhigrosIsarService.instance.getAllAvatarsSyncOrNull();
  }

  @override
  Future<void> persist(List<PhigrosAvatar> data) async {
    await PhigrosIsarService.instance.saveAvatars(data);
  }
}

class PhigrosRecordListResourceDefinition
    extends GameResourceDefinition<List<PhigrosGameRecord>> {
  const PhigrosRecordListResourceDefinition();

  @override
  ResourceKey<List<PhigrosGameRecord>> get key => phigrosRecordListResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _phigrosOnly;

  @override
  Duration? get ttl => const Duration(hours: 1);

  @override
  bool get accountRelated => true;

  @override
  List<ResourceKey> get dependencies => [phigrosSongListResourceKey];

  @override
  Future<List<PhigrosGameRecord>> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    if (account == null) {
      throw Exception('需要登录账号才能获取数据');
    }

    final accountId = _resolveAccountIdentifier(scope, account);
    final sessionToken = _requireSessionToken(account);

    await PhigrosScoreSyncService.instance.syncPlayerScoresToDatabase(
      accountId: accountId,
      sessionToken: sessionToken,
      onProgress: (_, __, ___) {},
    );

    return await PhigrosIsarService.instance.getGameRecords(accountId);
  }

  @override
  Future<List<PhigrosGameRecord>?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    if (!scope.hasAccount) return null;
    final accountId =
        scope.accountIdentifier ??
        account?.externalId ??
        account?.username ??
        account?.platformId;
    if (accountId == null || accountId.isEmpty) return null;
    final records = await PhigrosIsarService.instance.getGameRecords(accountId);
    return records;
  }

  @override
  Future<void> persist(List<PhigrosGameRecord> data) async {
    await PhigrosIsarService.instance.saveGameRecords(data);
  }
}

class PhigrosPlayerSummaryResourceDefinition
    extends GameResourceDefinition<PhigrosPlayerSummary> {
  const PhigrosPlayerSummaryResourceDefinition();

  @override
  ResourceKey<PhigrosPlayerSummary> get key =>
      phigrosPlayerSummaryResourceKey;

  @override
  List<PlatformId> get providedPlatforms => _phigrosOnly;

  @override
  Duration? get ttl => const Duration(hours: 1);

  @override
  bool get accountRelated => true;

  @override
  List<ResourceKey> get dependencies => [phigrosRecordListResourceKey];

  @override
  Future<PhigrosPlayerSummary> fetch(
    ResourceKey key,
    ResourceScope scope,
    List<PlatformAdapter> adapters,
    Account? account,
  ) async {
    if (account == null) {
      throw Exception('需要登录账号才能获取数据');
    }

    final accountId = _resolveAccountIdentifier(scope, account);
    final summary = await PhigrosIsarService.instance.getPlayerSummary(
      accountId,
    );

    if (summary != null) return summary;

    final records = await PhigrosIsarService.instance.getGameRecords(accountId);
    final calculated = PhigrosPlayerSummary.calculate(accountId, records, 0);
    await PhigrosIsarService.instance.savePlayerSummary(calculated);
    return calculated;
  }

  @override
  Future<PhigrosPlayerSummary?> loadCache(
    ResourceScope scope,
    Account? account,
  ) async {
    if (!scope.hasAccount) return null;
    final accountId =
        scope.accountIdentifier ??
        account?.externalId ??
        account?.username ??
        account?.platformId;
    if (accountId == null || accountId.isEmpty) return null;
    return PhigrosIsarService.instance.getPlayerSummary(accountId);
  }

  @override
  Future<void> persist(PhigrosPlayerSummary data) async {
    await PhigrosIsarService.instance.savePlayerSummary(data);
  }
}
