import 'package:rank_hub/core/resource_key.dart';
import 'package:rank_hub/models/phigros/avatar.dart';
import 'package:rank_hub/models/phigros/collection.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/player_summary.dart';
import 'package:rank_hub/models/phigros/song.dart';

final ResourceKey<List<PhigrosSong>> phigrosSongListResourceKey =
    ResourceKey<List<PhigrosSong>>(namespace: 'phigros', name: 'song_list');

final ResourceKey<List<PhigrosCollection>> phigrosCollectionListResourceKey =
    ResourceKey<List<PhigrosCollection>>(
      namespace: 'phigros',
      name: 'collection_list',
    );

final ResourceKey<List<PhigrosAvatar>> phigrosAvatarListResourceKey =
    ResourceKey<List<PhigrosAvatar>>(namespace: 'phigros', name: 'avatar_list');

final ResourceKey<List<PhigrosGameRecord>> phigrosRecordListResourceKey =
    ResourceKey<List<PhigrosGameRecord>>(
      namespace: 'phigros',
      name: 'record_list',
    );

final ResourceKey<PhigrosPlayerSummary> phigrosPlayerSummaryResourceKey =
    ResourceKey<PhigrosPlayerSummary>(
      namespace: 'phigros',
      name: 'player_summary',
    );
