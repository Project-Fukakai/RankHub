import 'package:rank_hub/games/maimai/models/maimai_score.dart';

class MaimaiBest50Data {
  final List<MaimaiScore> dxScores;
  final List<MaimaiScore> standardScores;
  final int dxTotal;
  final int standardTotal;

  const MaimaiBest50Data({
    required this.dxScores,
    required this.standardScores,
    required this.dxTotal,
    required this.standardTotal,
  });

  int get totalRating => dxTotal + standardTotal;
}
