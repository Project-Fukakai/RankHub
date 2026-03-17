import 'package:rank_hub/games/maimai/models/maimai_song.dart';

class MaimaiSongCatalog {
  final List<MaimaiSong> songs;
  final List<MaimaiVersion> versions;
  final List<MaimaiGenre> genres;
  final Map<int, List<String>> aliases;

  const MaimaiSongCatalog({
    required this.songs,
    required this.versions,
    required this.genres,
    required this.aliases,
  });
}
