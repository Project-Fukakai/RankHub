import 'package:isar_community/isar.dart';

part 'account_entity.g.dart';

/// Isar 账号实体
@Collection()
class AccountEntity {
  Id id = Isar.autoIncrement;

  /// 平台 ID
  @Index()
  late String platformId;

  /// 账号唯一标识（由平台定义，如用户ID、用户名等）
  @Index(unique: true, composite: [CompositeIndex('platformId')])
  late String accountIdentifier;

  /// 账号显示名称
  late String displayName;

  /// 头像 URL
  String? avatarUrl;

  /// 凭证数据（JSON 字符串）
  late String credentialsJson;

  /// 创建时间
  late DateTime createdAt;

  /// 最后更新时间
  late DateTime updatedAt;

  /// 额外元数据（JSON 字符串）
  String? metadataJson;

  AccountEntity();

  AccountEntity.create({
    required this.platformId,
    required this.accountIdentifier,
    required this.displayName,
    this.avatarUrl,
    required this.credentialsJson,
    this.metadataJson,
  }) {
    final now = DateTime.now();
    createdAt = now;
    updatedAt = now;
  }
}
