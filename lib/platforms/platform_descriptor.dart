import 'package:flutter/material.dart';
import 'package:rank_hub/core/credential_provider.dart';
import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/platform_adapter.dart';
import 'package:rank_hub/core/platform_id.dart';
import 'package:rank_hub/core/resource_key.dart';

class PlatformDescriptor {
  final PlatformId id;
  final String name;
  final String description;
  final IconData? iconData;
  final String? iconUrl;
  final CredentialProvider? credentialProvider;
  final PlatformLoginHandler? loginHandler;
  final PlatformAdapter? adapter;
  final List<GameId> supportedGames;
  final List<ResourceKey> providedResources;

  const PlatformDescriptor({
    required this.id,
    required this.name,
    required this.description,
    this.iconData,
    this.iconUrl,
    this.credentialProvider,
    this.loginHandler,
    this.adapter,
    this.supportedGames = const [],
    this.providedResources = const [],
  });

  bool supportsGame(GameId gameId) {
    return supportedGames.any((game) => game.value == gameId.value);
  }

  bool providesResource(ResourceKey key) {
    return providedResources.contains(key);
  }
}
