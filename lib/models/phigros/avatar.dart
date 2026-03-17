import 'package:isar_community/isar.dart';

part 'avatar.g.dart';

/// Phigros 头像
@collection
class PhigrosAvatar {
  Id id = Isar.autoIncrement;

  /// 头像名称（用于构建URL）
  @Index(unique: true)
  late String avatarName;

  /// 资源 key（来自公共资源）
  String? addressableKey;

  /// 头像URL
  String get avatarUrl =>
      'https://ghfast.top/https://raw.githubusercontent.com/7aGiven/Phigros_Resource/refs/heads/avatar/$avatarName.png';

  PhigrosAvatar();

  factory PhigrosAvatar.fromAllInfo(Map<String, dynamic> json) {
    return PhigrosAvatar()
      ..avatarName = json['name'] as String? ?? ''
      ..addressableKey = json['addressable_key'] as String?;
  }

  factory PhigrosAvatar.fromName(String name) {
    return PhigrosAvatar()
      ..avatarName = name.trim()
      ..addressableKey = null;
  }
}
