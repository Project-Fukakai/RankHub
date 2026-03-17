import 'package:isar_community/isar.dart';

part 'divingfish_song.g.dart';

/// 水鱼查分器曲目难度信息
@embedded
class DivingFishChartInfo {
  DivingFishChartInfo({this.notes = const [], this.charter = ''});

  /// 音符数量列表 [Tap, Hold, Slide, Touch(仅DX), Break]
  late List<int> notes;

  /// 谱师
  late String charter;

  factory DivingFishChartInfo.fromJson(Map<String, dynamic> json) {
    return DivingFishChartInfo(
      notes:
          (json['notes'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      charter: json['charter'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'notes': notes, 'charter': charter};
  }
}

/// 水鱼查分器曲目基本信息
@embedded
class DivingFishBasicInfo {
  DivingFishBasicInfo({
    this.title = '',
    this.artist = '',
    this.genre = '',
    this.bpm = 0,
    this.releaseDate = '',
    this.from = '',
    this.isNew = false,
  });

  late String title;
  late String artist;
  late String genre;
  late int bpm;
  late String releaseDate;
  late String from; // 稼动版本
  late bool isNew;

  factory DivingFishBasicInfo.fromJson(Map<String, dynamic> json) {
    return DivingFishBasicInfo(
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      bpm: (json['bpm'] as num?)?.toInt() ?? 0,
      releaseDate: json['release_date'] as String? ?? '',
      from: json['from'] as String? ?? '',
      isNew: json['is_new'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'genre': genre,
      'bpm': bpm,
      'release_date': releaseDate,
      'from': from,
      'is_new': isNew,
    };
  }
}

/// 水鱼查分器曲目
@collection
class DivingFishSong {
  DivingFishSong({
    this.id = Isar.autoIncrement,
    this.songId = 0,
    this.title = '',
    this.type = '',
    this.ds = const [],
    this.level = const [],
    this.cids = const [],
    this.charts = const [],
    this.basicInfo,
  });

  /// Isar 自增 ID
  Id id;

  /// 曲目 ID
  @Index(unique: true)
  late int songId;

  /// 曲名
  @Index(type: IndexType.value)
  late String title;

  /// 曲目类型 "DX" 或 "SD"
  late String type;

  /// 难度定数列表 (Basic -> Re:Master)
  late List<double> ds;

  /// 难度等级列表
  late List<String> level;

  /// 谱面唯一标识符列表
  late List<int> cids;

  /// 谱面信息列表
  late List<DivingFishChartInfo> charts;

  /// 基本信息
  late DivingFishBasicInfo? basicInfo;

  factory DivingFishSong.fromJson(Map<String, dynamic> json) {
    return DivingFishSong(
      songId: json['id'] is num
          ? (json['id'] as num).toInt()
          : (json['id'] is String
                ? int.tryParse(json['id'] as String) ?? 0
                : 0),
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      ds:
          (json['ds'] as List<dynamic>?)?.map((e) {
            if (e is num) {
              return e.toDouble();
            } else if (e is String) {
              return double.tryParse(e) ?? 0.0;
            }
            return 0.0;
          }).toList() ??
          [],
      level:
          (json['level'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cids:
          (json['cids'] as List<dynamic>?)?.map((e) {
            if (e is num) {
              return e.toInt();
            } else if (e is String) {
              return int.tryParse(e) ?? 0;
            }
            return 0;
          }).toList() ??
          [],
      charts:
          (json['charts'] as List<dynamic>?)
              ?.map(
                (e) => DivingFishChartInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      basicInfo: json['basic_info'] != null
          ? DivingFishBasicInfo.fromJson(
              json['basic_info'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': songId,
      'title': title,
      'type': type,
      'ds': ds,
      'level': level,
      'cids': cids,
      'charts': charts.map((e) => e.toJson()).toList(),
      'basic_info': basicInfo?.toJson(),
    };
  }

  /// 获取指定难度的定数
  double? getDsForDifficulty(int difficultyIndex) {
    if (difficultyIndex >= 0 && difficultyIndex < ds.length) {
      return ds[difficultyIndex];
    }
    return null;
  }

  /// 获取指定难度的等级
  String? getLevelForDifficulty(int difficultyIndex) {
    if (difficultyIndex >= 0 && difficultyIndex < level.length) {
      return level[difficultyIndex];
    }
    return null;
  }

  /// 获取曲绘 URL
  /// 格式: https://www.diving-fish.com/covers/{cover_id}.png
  /// ID 不足 5 位数时前面补 0
  String getCoverUrl() {
    final paddedId = songId.toString().padLeft(5, '0');
    return 'https://www.diving-fish.com/covers/$paddedId.png';
  }
}
