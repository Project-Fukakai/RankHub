import 'package:isar_community/isar.dart';

part 'song.g.dart';

/// Phigros 歌曲信息
@collection
class PhigrosSong {
  Id id = Isar.autoIncrement;

  /// 曲目ID（用于获取曲绘等资源）
  @Index(unique: true)
  late String songId;

  /// 曲名
  late String name;

  /// 曲师
  late String composer;

  /// 曲绘画师
  String? illustrator;

  /// 资源 key
  String? songKey;

  /// EZ谱师
  String? chartDesignerEZ;

  /// HD谱师
  String? chartDesignerHD;

  /// IN谱师
  String? chartDesignerIN;

  /// AT谱师（如有）
  String? chartDesignerAT;

  /// 所属收藏品
  String? collection;

  /// EZ定数
  double? difficultyEZ;

  /// HD定数
  double? difficultyHD;

  /// IN定数
  double? difficultyIN;

  /// AT定数（如有）
  double? difficultyAT;

  /// 预览开始时间
  double? previewTime;

  /// 预览结束时间
  double? previewEndTime;

  /// BPM
  String? bpm;

  /// 曲目时长
  String? length;

  /// 所属章节
  String? chapter;

  /// 是否有AT难度
  bool get hasAT => difficultyAT != null && difficultyAT! > 0;

  /// 曲绘URL
  String get illustrationUrl =>
      'https://ghfast.top/https://raw.githubusercontent.com/7aGiven/Phigros_Resource/refs/heads/illustration/$songId.png';

  /// 模糊曲绘URL
  String get illustrationBlurUrl =>
      'https://ghfast.top/https://raw.githubusercontent.com/7aGiven/Phigros_Resource/refs/heads/illustrationBlur/$songId.png';

  /// 低质量曲绘URL
  String get illustrationLowResUrl =>
      'https://ghfast.top/https://raw.githubusercontent.com/7aGiven/Phigros_Resource/refs/heads/illustrationLowRes/$songId.png';

  PhigrosSong();

  static String _normalizeSongId(String rawId) {
    if (rawId.endsWith('.0')) {
      return rawId.substring(0, rawId.length - 2);
    }
    return rawId;
  }

  static double? _numToDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory PhigrosSong.fromAllInfo(Map<String, dynamic> json) {
    final levels = json['levels'] as Map<String, dynamic>? ?? {};
    final ez = levels['EZ'] as Map<String, dynamic>?;
    final hd = levels['HD'] as Map<String, dynamic>?;
    final inn = levels['IN'] as Map<String, dynamic>?;
    final at = levels['AT'] as Map<String, dynamic>?;
    return PhigrosSong()
      ..songId = _normalizeSongId(json['id'] as String? ?? '')
      ..songKey = json['key'] as String?
      ..name = json['name'] as String? ?? ''
      ..composer = json['composer'] as String? ?? ''
      ..illustrator = json['illustrator'] as String?
      ..chartDesignerEZ = ez?['charter'] as String?
      ..chartDesignerHD = hd?['charter'] as String?
      ..chartDesignerIN = inn?['charter'] as String?
      ..chartDesignerAT = at?['charter'] as String?
      ..difficultyEZ = _numToDouble(ez?['difficulty'])
      ..difficultyHD = _numToDouble(hd?['difficulty'])
      ..difficultyIN = _numToDouble(inn?['difficulty'])
      ..difficultyAT = _numToDouble(at?['difficulty'])
      ..previewTime = _numToDouble(json['preview_time'])
      ..previewEndTime = _numToDouble(json['preview_end_time'])
      ..bpm = null
      ..length = null
      ..chapter = null;
  }

  /// 从info.tsv和difficulty.tsv的数据创建
  factory PhigrosSong.fromTsvData({
    required String songId,
    required String name,
    required String composer,
    String? illustrator,
    String? chartDesignerEZ,
    String? chartDesignerHD,
    String? chartDesignerIN,
    String? chartDesignerAT,
    String? collection,
    double? difficultyEZ,
    double? difficultyHD,
    double? difficultyIN,
    double? difficultyAT,
  }) {
    return PhigrosSong()
      ..songId = songId
      ..name = name
      ..composer = composer
      ..illustrator = illustrator
      ..chartDesignerEZ = chartDesignerEZ
      ..chartDesignerHD = chartDesignerHD
      ..chartDesignerIN = chartDesignerIN
      ..chartDesignerAT = chartDesignerAT
      ..collection = collection
      ..difficultyEZ = difficultyEZ
      ..difficultyHD = difficultyHD
      ..difficultyIN = difficultyIN
      ..difficultyAT = difficultyAT;
  }
}
