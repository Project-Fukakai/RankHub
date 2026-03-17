import 'package:isar_community/isar.dart';

part 'divingfish_alias.g.dart';

/// 曲目别名数据（来源：yuzuchan.moe alias API）
@collection
class DivingFishAlias {
  DivingFishAlias({
    this.id = Isar.autoIncrement,
    this.songId = 0,
    this.aliases = const [],
    this.name = '',
    this.isVotable = false,
  });

  /// Isar 自增 ID
  Id id;

  /// 曲目 ID，对应 diving-fish 曲目表
  @Index(unique: true)
  late int songId;

  /// 曲目名称（原始）
  late String name;

  /// 是否可投票（保留字段）
  late bool isVotable;

  /// 别名列表
  late List<String> aliases;

  factory DivingFishAlias.fromJson(Map<String, dynamic> json) {
    return DivingFishAlias(
      songId: _parseSongId(json),
      name: (json['Name'] ?? json['name'] ?? '').toString(),
      isVotable: (json['IsVotable'] ?? json['is_votable'] ?? false) as bool,
      aliases: _parseAliases(json['Alias'] ?? json['aliases']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SongID': songId,
      'Name': name,
      'IsVotable': isVotable,
      'Alias': aliases,
    };
  }

  static int _parseSongId(Map<String, dynamic> json) {
    final raw =
        json['SongID'] ?? json['song_id'] ?? json['songId'] ?? json['id'];
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw) ?? 0;
    return 0;
  }

  static List<String> _parseAliases(dynamic source) {
    if (source is List) {
      return source.map((e) => e.toString()).toList();
    }
    return const [];
  }
}
