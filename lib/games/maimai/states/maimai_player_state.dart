import 'package:flutter/foundation.dart';
import 'package:rank_hub/games/maimai/models/maimai_player.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';

/// Maimai 玩家状态
@immutable
class MaimaiPlayerState {
  final MaimaiPlayer? player;
  final List<MaimaiRatingTrend> ratingTrends;
  final DataLoadStatus loadStatus;
  final String? errorMessage;

  const MaimaiPlayerState({
    this.player,
    this.ratingTrends = const [],
    this.loadStatus = DataLoadStatus.idle,
    this.errorMessage,
  });

  MaimaiPlayerState copyWith({
    MaimaiPlayer? player,
    List<MaimaiRatingTrend>? ratingTrends,
    DataLoadStatus? loadStatus,
    String? errorMessage,
  }) {
    return MaimaiPlayerState(
      player: player ?? this.player,
      ratingTrends: ratingTrends ?? this.ratingTrends,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage,
    );
  }
}
