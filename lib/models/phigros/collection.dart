import 'package:isar_community/isar.dart';

part 'collection.g.dart';

/// Phigros 藏品条目
@embedded
class PhigrosCollectionFile {
  PhigrosCollectionFile({
    this.key = '',
    this.subIndex = 0,
    this.name = '',
    this.date = '',
    this.supervisor = '',
    this.category = '',
    this.content = '',
    this.properties = '',
  });

  /// 文件 key
  late String key;

  /// 子序号
  late int subIndex;

  /// 名称
  late String name;

  /// 日期
  late String date;

  /// 监督者
  late String supervisor;

  /// 分类
  late String category;

  /// 内容
  late String content;

  /// 其他属性
  late String properties;

  factory PhigrosCollectionFile.fromJson(Map<String, dynamic> json) {
    return PhigrosCollectionFile(
      key: json['key'] as String? ?? '',
      subIndex: json['sub_index'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      supervisor: json['supervisor'] as String? ?? '',
      category: json['category'] as String? ?? '',
      content: json['content'] as String? ?? '',
      properties: json['properties'] as String? ?? '',
    );
  }
}

/// Phigros 收藏品
@collection
class PhigrosCollection {
  Id id = Isar.autoIncrement;

  /// 收藏品ID
  @Index(unique: true)
  late String collectionId;

  /// 收藏品名称
  late String name;

  /// 数量
  late int count;

  /// 标题
  late String title;

  /// 子标题
  late String subTitle;

  /// 封面路径
  late String cover;

  /// 藏品条目
  late List<PhigrosCollectionFile> files;

  PhigrosCollection();

  String get coverUrl {
    if (cover.isEmpty) return '';
    if (cover.startsWith('http')) return cover;
    final normalized = _coverOverrides[cover] ?? cover;
    return 'https://somnia.xtower.site/${normalized.replaceAll('#', '%23')}';
  }

  static const Map<String, String> _coverOverrides = {
    'Assets/Tracks/#ChapterCover/Single.jpg': '/chap/单曲精选集.png',
    'Assets/Tracks/Dlyrotz.Likey.0/Illustration.jpg':
        '/illustration/Dlyrotz.Likey.png',
    'Assets/Tracks/光.姜米條.0/Illustration.jpg': '/illustration/光.姜米條.png',
    'Assets/Tracks/HumaN.SOTUI.0/Illustration.jpg':
        '/illustration/HumaN.SOTUI.png',
    'Assets/Tracks/#ChapterCover/MainStory4.jpg':
        '/illustration/SultanRage.MonstDeath.png',
    'Assets/Tracks/#ChapterCover/MainStory5.jpg':
        '/illustration/Spasmodic.姜米條颶風元力上人.png',
    'Assets/Tracks/#ChapterCover/MainStory6.jpg':
        '/illustration/Igallta.SeURa.png',
    'Assets/Tracks/#ChapterCover/MainStory7.jpg':
        '/illustration/Rrharil.TeamGrimoire.png',
    'Assets/Tracks/#ChapterCover/MainStory8.jpg':
        '/illustration/DistortedFate.Sakuzyo.png',
    'Assets/Tracks/#ChapterCover/SideStory1.jpg':
        '/illustration/MiracleForestVIPMix.Rinthlive.png',
    'Assets/Tracks/#ChapterCover/SideStory2.jpg': '/chap/Side Story 2 弭刻日.png',
    'Assets/Tracks/#ChapterCover/SideStory3jpg': '/chap/Side Story 3 盗乐行.png',
    'Assets/Tracks/#ChapterCover/SideStory4jpg':
        '/illustration/DerRichter.Ωμεγα.png',
    'Assets/Tracks/SATELLITE.かめりあ.0/Illustration.jpg':
        '/illustration/SATELLITE.かめりあ.png',
  };

  factory PhigrosCollection.fromAllInfo(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final subTitle = json['sub_title'] as String? ?? '';
    final files =
        (json['files'] as List?)
            ?.map(
              (e) => PhigrosCollectionFile.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        <PhigrosCollectionFile>[];
    final collectionId = subTitle.isEmpty ? title : '$title::$subTitle';
    return PhigrosCollection()
      ..collectionId = collectionId
      ..name = title
      ..count = files.length
      ..title = title
      ..subTitle = subTitle
      ..cover = json['cover'] as String? ?? ''
      ..files = files;
  }

  factory PhigrosCollection.fromTsvLine(String line) {
    final parts = line.split('\t');
    if (parts.length < 3) {
      throw Exception('Invalid collection data: $line');
    }

    final name = parts[1].trim();
    return PhigrosCollection()
      ..collectionId = parts[0].trim()
      ..name = name
      ..count = int.tryParse(parts[2].trim()) ?? 0
      ..title = name
      ..subTitle = ''
      ..cover = ''
      ..files = <PhigrosCollectionFile>[];
  }
}
