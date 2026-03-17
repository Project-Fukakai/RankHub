import 'package:flutter/foundation.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/data_load_status.dart';

/// 曲目筛选条件
@immutable
class SongFilter {
  final String searchKeyword;
  final String? selectedGenre;
  final int? selectedVersionId;
  final String? selectedType; // 'standard', 'dx', 'utage'

  const SongFilter({
    this.searchKeyword = '',
    this.selectedGenre,
    this.selectedVersionId,
    this.selectedType,
  });

  SongFilter copyWith({
    String? searchKeyword,
    String? selectedGenre,
    int? selectedVersionId,
    String? selectedType,
  }) {
    return SongFilter(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      selectedVersionId: selectedVersionId ?? this.selectedVersionId,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  /// 应用筛选逻辑
  List<MaimaiSong> apply(
    List<MaimaiSong> songs,
    Map<int, List<String>> aliases,
    List<MaimaiVersion> versions,
  ) {
    final keyword = searchKeyword.toLowerCase();

    return songs.where((song) {
      // 搜索条件: 曲名、艺术家、谱师、分类、别名
      final matchesSearch =
          keyword.isEmpty ||
          song.title.toLowerCase().contains(keyword) ||
          song.artist.toLowerCase().contains(keyword) ||
          song.genre.toLowerCase().contains(keyword) ||
          _matchesNoteDesigner(song, keyword) ||
          _matchesAlias(song, keyword, aliases);

      // 分类筛选
      final matchesGenre = selectedGenre == null || song.genre == selectedGenre;

      // 版本筛选
      bool matchesVersion = true;
      if (selectedVersionId != null) {
        final songVersion = _getVersionBySongVersion(song.version, versions);
        matchesVersion =
            songVersion != null && songVersion.versionId == selectedVersionId;
      }

      // 谱面类型筛选
      final matchesType = selectedType == null || _hasType(song, selectedType!);

      return matchesSearch && matchesGenre && matchesVersion && matchesType;
    }).toList();
  }

  /// 检查曲目是否有指定类型的谱面
  bool _hasType(MaimaiSong song, String type) {
    switch (type) {
      case 'standard':
        return song.difficulties.standard.isNotEmpty;
      case 'dx':
        return song.difficulties.dx.isNotEmpty;
      case 'utage':
        return song.difficulties.utage.isNotEmpty;
      default:
        return true;
    }
  }

  /// 检查是否匹配谱师
  bool _matchesNoteDesigner(MaimaiSong song, String keyword) {
    for (var diff in song.difficulties.standard) {
      if (diff.noteDesigner.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    for (var diff in song.difficulties.dx) {
      if (diff.noteDesigner.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// 检查是否匹配别名
  bool _matchesAlias(
    MaimaiSong song,
    String keyword,
    Map<int, List<String>> aliases,
  ) {
    final songAliases = aliases[song.songId] ?? [];
    for (var alias in songAliases) {
      if (alias.toLowerCase().contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// 根据曲目版本号获取所属版本信息
  MaimaiVersion? _getVersionBySongVersion(
    int songVersion,
    List<MaimaiVersion> versions,
  ) {
    if (versions.isEmpty) return null;

    // versions 已按降序排列
    if (songVersion >= versions.first.version) {
      return versions.first;
    }

    if (songVersion < versions.last.version) {
      return versions.last;
    }

    for (int i = 0; i < versions.length - 1; i++) {
      final currentVersion = versions[i];
      final nextVersion = versions[i + 1];

      if (songVersion >= nextVersion.version &&
          songVersion < currentVersion.version) {
        return nextVersion;
      }
    }

    return null;
  }
}

/// Maimai 曲目状态
@immutable
class MaimaiSongState {
  final List<MaimaiSong> allSongs;
  final List<MaimaiSong> filteredSongs;
  final SongFilter currentFilter;
  final DataLoadStatus loadStatus;
  final String? errorMessage;
  final bool isFromCache;

  // 元数据
  final List<MaimaiVersion> versions;
  final List<MaimaiGenre> genres;
  final Map<int, List<String>> aliases;

  const MaimaiSongState({
    this.allSongs = const [],
    this.filteredSongs = const [],
    this.currentFilter = const SongFilter(),
    this.loadStatus = DataLoadStatus.idle,
    this.errorMessage,
    this.isFromCache = false,
    this.versions = const [],
    this.genres = const [],
    this.aliases = const {},
  });

  MaimaiSongState copyWith({
    List<MaimaiSong>? allSongs,
    List<MaimaiSong>? filteredSongs,
    SongFilter? currentFilter,
    DataLoadStatus? loadStatus,
    String? errorMessage,
    bool? isFromCache,
    List<MaimaiVersion>? versions,
    List<MaimaiGenre>? genres,
    Map<int, List<String>>? aliases,
  }) {
    return MaimaiSongState(
      allSongs: allSongs ?? this.allSongs,
      filteredSongs: filteredSongs ?? this.filteredSongs,
      currentFilter: currentFilter ?? this.currentFilter,
      loadStatus: loadStatus ?? this.loadStatus,
      errorMessage: errorMessage,
      isFromCache: isFromCache ?? this.isFromCache,
      versions: versions ?? this.versions,
      genres: genres ?? this.genres,
      aliases: aliases ?? this.aliases,
    );
  }

  /// 获取所有分类名称
  List<String> getGenreNames() {
    final genreNames = genres.map((g) => g.genre).toSet().toList();
    genreNames.sort();
    return genreNames;
  }

  /// 获取谱面类型选项
  List<Map<String, String>> getTypeOptions() {
    return [
      {'value': 'standard', 'label': 'Standard'},
      {'value': 'dx', 'label': 'DX'},
      {'value': 'utage', 'label': '宴会场'},
    ];
  }
}
