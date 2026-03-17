import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rank_hub/models/phigros/avatar.dart';
import 'package:rank_hub/models/phigros/chart.dart';
import 'package:rank_hub/models/phigros/collection.dart';
import 'package:rank_hub/models/phigros/song.dart';

class PhigrosAllInfo {
  final List<PhigrosSong> songs;
  final List<PhigrosCollection> collections;
  final List<PhigrosAvatar> avatars;
  final List<String> tips;

  const PhigrosAllInfo({
    required this.songs,
    required this.collections,
    required this.avatars,
    required this.tips,
  });

  factory PhigrosAllInfo.fromJson(Map<String, dynamic> json) {
    final songs =
        (json['songs'] as List?)
            ?.map((e) => PhigrosSong.fromAllInfo(e as Map<String, dynamic>))
            .toList() ??
        <PhigrosSong>[];
    final collections =
        (json['collection'] as List?)
            ?.map(
              (e) => PhigrosCollection.fromAllInfo(e as Map<String, dynamic>),
            )
            .toList() ??
        <PhigrosCollection>[];
    final avatars =
        (json['avatars'] as List?)
            ?.map((e) => PhigrosAvatar.fromAllInfo(e as Map<String, dynamic>))
            .toList() ??
        <PhigrosAvatar>[];
    final tips =
        (json['tips'] as List?)?.map((e) => e.toString()).toList() ??
        <String>[];
    return PhigrosAllInfo(
      songs: songs,
      collections: collections,
      avatars: avatars,
      tips: tips,
    );
  }
}

class PhigrosSongInfo {
  final String bpm;
  final String length;
  final String chapter;

  const PhigrosSongInfo({
    required this.bpm,
    required this.length,
    required this.chapter,
  });

  factory PhigrosSongInfo.fromJson(Map<String, dynamic> json) {
    return PhigrosSongInfo(
      bpm: json['bpm']?.toString() ?? '',
      length: json['length']?.toString() ?? '',
      chapter: json['chapter']?.toString() ?? '',
    );
  }
}

/// Phigros 资源 API 服务
class PhigrosResourceApiService {
  static final PhigrosResourceApiService _instance =
      PhigrosResourceApiService._internal();

  factory PhigrosResourceApiService() => _instance;

  static PhigrosResourceApiService get instance => _instance;

  PhigrosResourceApiService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://somnia.xtower.site',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'User-Agent': 'Mozilla/5.0 (RankHub)',
        'Accept': 'application/json',
      },
    ),
  );

  PhigrosAllInfo? _allInfoCache;
  Future<PhigrosAllInfo>? _allInfoFuture;
  Map<String, PhigrosSongInfo>? _infoListCache;
  Future<Map<String, PhigrosSongInfo>>? _infoListFuture;

  /// 获取公共资源（统一入口）
  Future<PhigrosAllInfo> fetchAllInfo({bool forceRefresh = false}) async {
    if (!forceRefresh && _allInfoCache != null) {
      return _allInfoCache!;
    }
    if (!forceRefresh && _allInfoFuture != null) {
      return _allInfoFuture!;
    }

    _allInfoFuture = _fetchAllInfoInternal();
    try {
      final data = await _allInfoFuture!;
      _allInfoCache = data;
      return data;
    } finally {
      _allInfoFuture = null;
    }
  }

  /// 获取歌曲额外信息（BPM/时长/章节）
  Future<Map<String, PhigrosSongInfo>> fetchInfoList({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _infoListCache != null) {
      return _infoListCache!;
    }
    if (!forceRefresh && _infoListFuture != null) {
      return _infoListFuture!;
    }

    _infoListFuture = _fetchInfoListInternal();
    try {
      final data = await _infoListFuture!;
      _infoListCache = data;
      return data;
    } finally {
      _infoListFuture = null;
    }
  }

  Future<PhigrosAllInfo> _fetchAllInfoInternal() async {
    try {
      print('📥 开始获取公共资源 all_info.json...');
      final response = await _dio.get<dynamic>(
        '/info/all_info.json',
        options: Options(responseType: ResponseType.json),
      );
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final Map<String, dynamic> data = responseData is Map<String, dynamic>
            ? responseData
            : responseData is String
            ? jsonDecode(responseData) as Map<String, dynamic>
            : Map<String, dynamic>.from(responseData as Map);
        final allInfo = PhigrosAllInfo.fromJson(data);
        print(
          '✅ 获取公共资源完成: ${allInfo.songs.length} 首曲目, '
          '${allInfo.collections.length} 个藏品, '
          '${allInfo.avatars.length} 个头像',
        );
        return allInfo;
      }

      throw Exception('获取公共资源失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取公共资源失败: $e');
      rethrow;
    }
  }

  Future<Map<String, PhigrosSongInfo>> _fetchInfoListInternal() async {
    try {
      print('📥 开始获取 infolist.json...');
      final response = await _dio.get<dynamic>(
        '/info/infolist.json',
        options: Options(responseType: ResponseType.json),
      );
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final Map<String, dynamic> data = responseData is Map<String, dynamic>
            ? responseData
            : responseData is String
            ? jsonDecode(responseData) as Map<String, dynamic>
            : Map<String, dynamic>.from(responseData as Map);
        final result = <String, PhigrosSongInfo>{};
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            result[key] = PhigrosSongInfo.fromJson(value);
          } else if (value is Map) {
            result[key] = PhigrosSongInfo.fromJson(
              Map<String, dynamic>.from(value),
            );
          }
        });
        print('✅ 获取 infolist 完成: ${result.length} 条');
        return result;
      }

      throw Exception('获取 infolist 失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取 infolist 失败: $e');
      rethrow;
    }
  }

  /// 获取乐曲信息
  Future<List<PhigrosSong>> fetchSongs() async {
    try {
      print('📥 开始获取乐曲信息...');
      final allInfo = await fetchAllInfo();
      final infoList = await fetchInfoList();
      for (final song in allInfo.songs) {
        final info = infoList[song.songId];
        if (info == null) continue;
        song
          ..bpm = info.bpm
          ..length = info.length
          ..chapter = info.chapter;
      }
      return allInfo.songs;
    } catch (e) {
      print('❌ 获取乐曲信息失败: $e');
      rethrow;
    }
  }

  /// 获取收藏品列表
  Future<List<PhigrosCollection>> fetchCollections() async {
    try {
      print('📥 开始获取收藏品...');
      final allInfo = await fetchAllInfo();
      return allInfo.collections;
    } catch (e) {
      print('❌ 获取收藏品失败: $e');
      rethrow;
    }
  }

  /// 获取头像名称列表
  Future<List<PhigrosAvatar>> fetchAvatars() async {
    try {
      print('📥 开始获取头像列表...');
      final allInfo = await fetchAllInfo();
      return allInfo.avatars;
    } catch (e) {
      print('❌ 获取头像列表失败: $e');
      rethrow;
    }
  }

  /// 获取谱面数据
  /// [songId] 曲目ID（格式：曲名.曲师）
  /// [difficulty] 难度（EZ/HD/IN/AT）
  Future<PhigrosChart> fetchChart(String songId, String difficulty) async {
    try {
      // URL 格式: /chart/{songId}.0/{difficulty}.json
      final url = '/chart/$songId.0/$difficulty.json';

      print('📥 开始获取谱面: $songId - $difficulty');
      print('   URL: $url');

      final response = await _dio.get<String>(url);
      final responseData = response.data;

      if (response.statusCode == 200 && responseData != null) {
        final chart = PhigrosChart.fromJson(
          jsonDecode(responseData) as Map<String, dynamic>,
        );
        print('✅ 获取谱面完成: ${chart.totalNotes} 个音符');
        return chart;
      }

      throw Exception('获取谱面失败: ${response.statusCode}');
    } catch (e) {
      print('❌ 获取谱面失败: $songId - $difficulty, 错误: $e');
      rethrow;
    }
  }

  /// 批量获取谱面数据
  /// [songId] 曲目ID
  /// [difficulties] 难度列表，默认获取所有难度
  Future<Map<String, PhigrosChart>> fetchCharts(
    String songId, {
    List<String>? difficulties,
  }) async {
    final diffList = difficulties ?? ['EZ', 'HD', 'IN', 'AT'];
    final charts = <String, PhigrosChart>{};

    for (final diff in diffList) {
      try {
        final chart = await fetchChart(songId, diff);
        charts[diff] = chart;
      } catch (e) {
        print('⚠️ 跳过难度 $diff: $e');
      }
    }

    return charts;
  }
}
