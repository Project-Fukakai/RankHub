import 'package:rank_hub/games/maimai/models/divingfish/divingfish_song.dart';

/// 合并后的曲目（包含 SD 和 DX 版本）
class DivingFishMergedSong {
  /// 曲名
  final String title;

  /// SD 版本曲目（可能为空）
  final DivingFishSong? sdVersion;

  /// DX 版本曲目（可能为空）
  final DivingFishSong? dxVersion;

  /// 基本信息（优先使用 DX 版本，否则使用 SD 版本）
  DivingFishBasicInfo? get basicInfo =>
      dxVersion?.basicInfo ?? sdVersion?.basicInfo;

  /// 是否同时有 SD 和 DX 版本
  bool get hasBothVersions => sdVersion != null && dxVersion != null;

  /// 是否只有 SD 版本
  bool get hasOnlySD => sdVersion != null && dxVersion == null;

  /// 是否只有 DX 版本
  bool get hasOnlyDX => dxVersion != null && sdVersion == null;

  DivingFishMergedSong({required this.title, this.sdVersion, this.dxVersion})
    : assert(sdVersion != null || dxVersion != null, '至少需要一个版本');

  /// 从曲目列表创建合并列表
  static List<DivingFishMergedSong> mergeFromSongs(List<DivingFishSong> songs) {
    // 按曲名分组
    final Map<String, List<DivingFishSong>> groupedByTitle = {};
    for (final song in songs) {
      groupedByTitle.putIfAbsent(song.title, () => []).add(song);
    }

    // 合并同名曲目
    final List<DivingFishMergedSong> mergedSongs = [];
    groupedByTitle.forEach((title, songList) {
      DivingFishSong? sdVersion;
      DivingFishSong? dxVersion;

      for (final song in songList) {
        if (song.type == 'SD') {
          sdVersion = song;
        } else if (song.type == 'DX') {
          dxVersion = song;
        }
      }

      mergedSongs.add(
        DivingFishMergedSong(
          title: title,
          sdVersion: sdVersion,
          dxVersion: dxVersion,
        ),
      );
    });

    return mergedSongs;
  }

  /// 用于搜索的文本内容
  String get searchableText {
    final parts = <String>[title];

    if (basicInfo?.artist != null) {
      parts.add(basicInfo!.artist);
    }
    if (basicInfo?.genre != null) {
      parts.add(basicInfo!.genre);
    }

    // 添加所有谱师信息
    sdVersion?.charts.forEach((chart) => parts.add(chart.charter));
    dxVersion?.charts.forEach((chart) => parts.add(chart.charter));

    return parts.join(' ').toLowerCase();
  }
}
