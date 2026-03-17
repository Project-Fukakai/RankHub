import 'package:rank_hub/core/game_id.dart';
import 'package:rank_hub/core/game_descriptor.dart';

abstract class Game {
  GameId get id;
  String get name;
  GameDescriptor get descriptor;
}
