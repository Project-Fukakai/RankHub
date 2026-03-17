import 'package:isar_community/isar.dart';
import 'package:rank_hub/models/maimai/enums/level_index.dart';
import 'package:rank_hub/models/maimai/enums/fc_type.dart';
import 'package:rank_hub/models/maimai/enums/fs_type.dart';
import 'package:rank_hub/models/maimai/enums/rate_type.dart';

part 'divingfish_score.g.dart';

/// 水鱼查分器 - 玩家成绩记录
@collection
class DivingFishScore {
  DivingFishScore({
    this.id = Isar.autoIncrement,
    this.songId = 0,
    this.title = '',
    this.level = '',
    this.levelIndex = 0,
    this.levelLabel = '',
    this.achievements = 0.0,
    this.ds = 0.0,
    this.dxScore = 0,
    this.fc = '',
    this.fs = '',
    this.ra = 0,
    this.rate = '',
    this.type = '',
  });

  /// Isar 自增 ID
  Id id;

  /// 曲目 ID
  late int songId;

  /// 歌曲标题
  late String title;

  /// 谱面等级（如 "14+"）
  late String level;

  /// 谱面难度索引（0-4）
  late int levelIndex;

  /// 难度标签（如 "Master"）
  late String levelLabel;

  /// 达成率（百分比）
  late double achievements;

  /// 谱面定数
  late double ds;

  /// DX 分数
  late int dxScore;

  /// FC 状态（fc、fcp、ap、app）
  late String fc;

  /// FS 状态（sync、fs、fsp、fsd、fsdp）
  late String fs;

  /// 单曲 rating
  late int ra;

  /// 评级（如 "sssp"）
  late String rate;

  /// 歌曲类型（DX 或 SD）
  late String type;

  /// 复合索引：songId + levelIndex + type 唯一标识一条成绩
  @Index(
    composite: [CompositeIndex('levelIndex'), CompositeIndex('type')],
    unique: true,
  )
  int get scoreKey => songId;

  /// 从 JSON 创建
  factory DivingFishScore.fromJson(Map<String, dynamic> json) {
    return DivingFishScore(
      songId: json['song_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      level: json['level'] as String? ?? '',
      levelIndex: json['level_index'] as int? ?? 0,
      levelLabel: json['level_label'] as String? ?? '',
      achievements: (json['achievements'] as num?)?.toDouble() ?? 0.0,
      ds: (json['ds'] as num?)?.toDouble() ?? 0.0,
      dxScore: json['dxScore'] as int? ?? 0,
      fc: json['fc'] as String? ?? '',
      fs: json['fs'] as String? ?? '',
      ra: json['ra'] as int? ?? 0,
      rate: json['rate'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'song_id': songId,
      'title': title,
      'level': level,
      'level_index': levelIndex,
      'level_label': levelLabel,
      'achievements': achievements,
      'ds': ds,
      'dxScore': dxScore,
      'fc': fc,
      'fs': fs,
      'ra': ra,
      'rate': rate,
      'type': type,
    };
  }

  /// 获取 LevelIndex 枚举
  @ignore
  LevelIndex get levelIndexEnum => LevelIndex.fromValue(levelIndex);

  /// 获取 FCType 枚举（可能为 null）
  @ignore
  FCType? get fcType {
    if (fc.isEmpty) return null;
    switch (fc.toLowerCase()) {
      case 'fc':
        return FCType.fc;
      case 'fcp':
        return FCType.fcPlus;
      case 'ap':
        return FCType.ap;
      case 'app':
        return FCType.apPlus;
      default:
        return null;
    }
  }

  /// 获取 FSType 枚举（可能为 null）
  @ignore
  FSType? get fsType {
    if (fs.isEmpty) return null;
    switch (fs.toLowerCase()) {
      case 'sync':
        return FSType.sync;
      case 'fs':
        return FSType.fs;
      case 'fsp':
        return FSType.fsPlus;
      case 'fsd':
        return FSType.fsd;
      case 'fsdp':
        return FSType.fsdPlus;
      default:
        return null;
    }
  }

  /// 获取 RateType 枚举（可能为 null）
  @ignore
  RateType? get rateType {
    if (rate.isEmpty) return null;
    switch (rate.toLowerCase()) {
      case 'd':
        return RateType.d;
      case 'c':
        return RateType.c;
      case 'b':
        return RateType.b;
      case 'bb':
        return RateType.bb;
      case 'bbb':
        return RateType.bbb;
      case 'a':
        return RateType.a;
      case 'aa':
        return RateType.aa;
      case 'aaa':
        return RateType.aaa;
      case 's':
        return RateType.s;
      case 'sp':
        return RateType.sPlus;
      case 'ss':
        return RateType.ss;
      case 'ssp':
        return RateType.ssPlus;
      case 'sss':
        return RateType.sss;
      case 'sssp':
        return RateType.sssPlus;
      default:
        return null;
    }
  }
}

/// 水鱼查分器 - 玩家信息和成绩汇总
@collection
class DivingFishPlayerData {
  DivingFishPlayerData({
    this.id = Isar.autoIncrement,
    this.username = '',
    this.nickname = '',
    this.rating = 0,
    this.additionalRating = 0,
    this.plate = '',
    this.lastUpdated,
  });

  /// Isar 自增 ID
  Id id;

  /// 用户名（唯一）
  @Index(unique: true)
  late String username;

  /// 昵称
  late String nickname;

  /// Rating 值
  late int rating;

  /// 段位信息
  late int additionalRating;

  /// 牌子信息
  late String plate;

  /// 最后更新时间
  DateTime? lastUpdated;

  /// 从 JSON 创建
  factory DivingFishPlayerData.fromJson(Map<String, dynamic> json) {
    return DivingFishPlayerData(
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      additionalRating: json['additional_rating'] as int? ?? 0,
      plate: json['plate'] as String? ?? '',
      lastUpdated: DateTime.now(),
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'rating': rating,
      'additional_rating': additionalRating,
      'plate': plate,
    };
  }
}
