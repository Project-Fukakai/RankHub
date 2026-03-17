import 'package:rank_hub/core/credential_provider.dart';
import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/platforms/platform_descriptor.dart';

class PlatformRegistry {
  final Map<String, PlatformDescriptor> _platforms = {};

  void registerPlatform(PlatformDescriptor descriptor) {
    final key = descriptor.id.value;
    if (_platforms.containsKey(key)) {
      throw Exception('Platform already registered: $key');
    }
    _platforms[key] = descriptor;
  }

  void registerPlatforms(List<PlatformDescriptor> platforms) {
    for (final platform in platforms) {
      registerPlatform(platform);
    }
  }

  PlatformDescriptor? findById(PlatformId id) {
    return _platforms[id.value];
  }

  PlatformDescriptor? findByIdString(String id) {
    return _platforms[id];
  }

  List<PlatformDescriptor> getAllPlatforms() {
    return _platforms.values.toList();
  }

  List<PlatformId> getAllPlatformIds() {
    return _platforms.keys.map((id) => PlatformId(id)).toList();
  }

  List<PlatformDescriptor> getPlatformsForGame(GameId gameId) {
    return _platforms.values.where((p) => p.supportsGame(gameId)).toList();
  }

  List<GameId> getGamesForPlatform(PlatformId platformId) {
    final platform = findById(platformId);
    if (platform == null) return [];
    return platform.supportedGames.toList();
  }

  bool isPlatformSupportGame(PlatformId platformId, GameId gameId) {
    final platform = findById(platformId);
    if (platform == null) return false;
    return platform.supportsGame(gameId);
  }

  CredentialProvider? getCredentialProvider(PlatformId platformId) {
    return findById(platformId)?.credentialProvider;
  }

  PlatformLoginHandler? getLoginHandler(PlatformId platformId) {
    return findById(platformId)?.loginHandler;
  }

  List<CredentialProvider> getAllCredentialProviders() {
    return _platforms.values
        .map((platform) => platform.credentialProvider)
        .whereType<CredentialProvider>()
        .toList();
  }

  List<PlatformLoginHandler> getAllLoginHandlers() {
    return _platforms.values
        .map((platform) => platform.loginHandler)
        .whereType<PlatformLoginHandler>()
        .toList();
  }

  List<PlatformAdapter> getAdaptersForGame(GameId gameId) {
    return _platforms.values
        .where((platform) => platform.supportsGame(gameId))
        .map((platform) => platform.adapter)
        .whereType<PlatformAdapter>()
        .toList();
  }

  List<PlatformAdapter> resolveAdaptersForResource({
    required GameId gameId,
    required ResourceKey key,
    required bool accountRelated,
    String? accountPlatformId,
  }) {
    final candidates = getPlatformsForResource(gameId, key);

    if (accountRelated) {
      if (accountPlatformId == null) return [];
      return candidates
          .where((platform) => platform.id.value == accountPlatformId)
          .map((platform) => platform.adapter)
          .whereType<PlatformAdapter>()
          .toList();
    }

    if (candidates.isEmpty) return [];
    return candidates
        .map((platform) => platform.adapter)
        .whereType<PlatformAdapter>()
        .toList();
  }

  List<PlatformDescriptor> getPlatformsForResource(
    GameId gameId,
    ResourceKey key,
  ) {
    return _platforms.values.where((platform) {
      if (!platform.supportsGame(gameId)) return false;
      if (platform.providedResources.isEmpty) return false;
      return platform.providesResource(key);
    }).toList();
  }

  void clear() {
    _platforms.clear();
  }

  int get platformCount => _platforms.length;

  int get adapterCount =>
      _platforms.values.where((platform) => platform.adapter != null).length;

  int get credentialProviderCount => _platforms.values
      .where((platform) => platform.credentialProvider != null)
      .length;

  int get loginHandlerCount =>
      _platforms.values.where((platform) => platform.loginHandler != null).length;
}
