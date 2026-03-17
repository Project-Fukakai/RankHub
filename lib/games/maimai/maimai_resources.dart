import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/games/maimai/models/maimai_best50_data.dart';
import 'package:rank_hub/games/maimai/models/maimai_collection.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/maimai_song_catalog.dart';
import 'package:rank_hub/games/maimai/models/net_score.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';

final ResourceKey<List<MaimaiSong>> maimaiSongListResourceKey =
    ResourceKey<List<MaimaiSong>>(namespace: 'maimai', name: 'song_list');

final ResourceKey<MaimaiSongCatalog> maimaiSongCatalogResourceKey =
    ResourceKey<MaimaiSongCatalog>(namespace: 'maimai', name: 'song_catalog');

final ResourceKey<List<MaimaiVersion>> maimaiVersionListResourceKey =
    ResourceKey<List<MaimaiVersion>>(namespace: 'maimai', name: 'version_list');

final ResourceKey<List<MaimaiGenre>> maimaiGenreListResourceKey =
    ResourceKey<List<MaimaiGenre>>(namespace: 'maimai', name: 'genre_list');

final ResourceKey<Map<int, List<String>>> maimaiAliasMapResourceKey =
    ResourceKey<Map<int, List<String>>>(namespace: 'maimai', name: 'alias_map');

final ResourceKey<List<MaimaiCollection>> maimaiCollectionListResourceKey =
    ResourceKey<List<MaimaiCollection>>(
      namespace: 'maimai',
      name: 'collection_list',
    );

final ResourceKey<List<MaimaiCollectionGenre>>
maimaiCollectionGenreListResourceKey =
    ResourceKey<List<MaimaiCollectionGenre>>(
      namespace: 'maimai',
      name: 'collection_genre_list',
    );

final ResourceKey<List<MaimaiScore>> maimaiScoreListResourceKey =
    ResourceKey<List<MaimaiScore>>(namespace: 'maimai', name: 'score_list');

final ResourceKey<MaimaiPlayer> maimaiPlayerResourceKey =
    ResourceKey<MaimaiPlayer>(namespace: 'maimai', name: 'player_info');

final ResourceKey<MaimaiBest50Data> maimaiBest50ResourceKey =
    ResourceKey<MaimaiBest50Data>(namespace: 'maimai', name: 'best50');

final ResourceKey<List<Map<String, dynamic>>> maimaiScoreHistoryResourceKey =
    ResourceKey<List<Map<String, dynamic>>>(
      namespace: 'maimai',
      name: 'score_history',
    );

final ResourceKey<UserPreview> maimaiNetUserPreviewResourceKey =
    ResourceKey<UserPreview>(namespace: 'maimai', name: 'net_user_preview');

final ResourceKey<List<NetScore>> maimaiNetUserScoresResourceKey =
    ResourceKey<List<NetScore>>(namespace: 'maimai', name: 'net_user_scores');

ResourceKey<List<Map<String, dynamic>>> maimaiScoreHistoryKey({
  required int songId,
  required int levelIndex,
  required String songType,
}) {
  final scope =
      'songId=$songId&levelIndex=$levelIndex&songType=${Uri.encodeComponent(songType)}';
  return ResourceKey<List<Map<String, dynamic>>>(
    namespace: 'maimai',
    name: 'score_history',
    scope: scope,
  );
}

ResourceKey<UserPreview> maimaiNetUserPreviewKey(String qrCode) {
  return ResourceKey<UserPreview>(
    namespace: 'maimai',
    name: 'net_user_preview',
    scope: Uri.encodeComponent(qrCode),
  );
}

ResourceKey<List<NetScore>> maimaiNetUserScoresKey(String qrCode) {
  return ResourceKey<List<NetScore>>(
    namespace: 'maimai',
    name: 'net_user_scores',
    scope: Uri.encodeComponent(qrCode),
  );
}
