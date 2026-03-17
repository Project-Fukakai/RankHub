import 'package:isar_community/isar.dart';

part 'pinned_collection.g.dart';

/// 用户固定的藏品配置
@collection
class PinnedCollection {
  PinnedCollection({
    this.id = Isar.autoIncrement,
    required this.collectionId,
    required this.collectionType,
    this.pinnedAt,
  });

  /// Isar 自增 ID
  Id id;

  /// 收藏品 ID
  late int collectionId;

  /// 收藏品类型 (trophy, icon, plate, frame)
  late String collectionType;

  /// 固定时间
  DateTime? pinnedAt;

  /// 复合索引：collectionType + collectionId 唯一
  @Index(composite: [CompositeIndex('collectionId')], unique: true)
  String get typeIdKey => '$collectionType-$collectionId';

  factory PinnedCollection.fromJson(Map<String, dynamic> json) {
    return PinnedCollection(
      collectionId: json['collectionId'] as int,
      collectionType: json['collectionType'] as String,
      pinnedAt: json['pinnedAt'] != null
          ? DateTime.parse(json['pinnedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionId': collectionId,
      'collectionType': collectionType,
      'pinnedAt': pinnedAt?.toIso8601String(),
    };
  }
}
