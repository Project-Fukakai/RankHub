import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Phigros API 服务
class PhigrosApiService {
  static final PhigrosApiService _instance = PhigrosApiService._internal();

  factory PhigrosApiService() => _instance;

  static PhigrosApiService get instance => _instance;

  PhigrosApiService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rak3ffdi.cloud.tds1.tapapis.cn/1.1',
      headers: {
        'X-LC-Id': 'rAK3FfdieFob2Nn8Am',
        'X-LC-Key': 'Qr9AEqtuoSVS3zeD6iVbM4ZC0AtkJcQ89tywVyi0',
        'User-Agent': 'LeanCloud-CSharp-SDK/1.0.3',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// 获取用户信息
  ///
  /// 参数:
  /// - sessionToken: 用户的 session token
  ///
  /// 返回用户信息，包括昵称、头像等
  Future<PhigrosUserInfo> getUserInfo(String sessionToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/users/me',
        options: Options(headers: {'X-LC-Session': sessionToken}),
      );
      final responseData = response.data;
      if (responseData == null) {
        throw Exception("获取用户信息失败: 空返回");
      }
      if (response.statusCode == 200) {
        return PhigrosUserInfo.fromJson(responseData);
      } else {
        throw Exception('获取用户信息失败: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session Token 无效或已过期');
      }
      throw Exception('网络请求失败: ${e.message}');
    }
  }

  /// 获取游戏存档数据
  ///
  /// 参数:
  /// - sessionToken: 用户的 session token
  ///
  /// 返回游戏存档数据
  Future<PhigrosGameSave?> getGameSave(String sessionToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/classes/_GameSave',
        queryParameters: {'limit': 1},
        options: Options(headers: {'X-LC-Session': sessionToken}),
      );

      if (response.statusCode == 200) {
        final results = response.data?['results'] as List?;
        if (results != null && results.isNotEmpty) {
          return PhigrosGameSave.fromJson(results[0]);
        }
        return null;
      } else {
        throw Exception('获取游戏数据失败: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session Token 无效或已过期');
      }
      throw Exception('网络请求失败: ${e.message}');
    }
  }

  /// 验证 Session Token 是否有效
  Future<bool> validateSessionToken(String sessionToken) async {
    try {
      await getUserInfo(sessionToken);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Phigros 用户信息
class PhigrosUserInfo {
  final String objectId;
  final String username;
  final String nickname;
  final String? avatar;
  final String sessionToken;
  final String? shortId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PhigrosUserInfo({
    required this.objectId,
    required this.username,
    required this.nickname,
    this.avatar,
    required this.sessionToken,
    this.shortId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhigrosUserInfo.fromJson(Map<String, dynamic> json) {
    return PhigrosUserInfo(
      objectId: json['objectId'] as String,
      username: json['username'] as String,
      nickname: json['nickname'] as String? ?? json['username'] as String,
      avatar: json['avatar'] as String?,
      sessionToken: json['sessionToken'] as String,
      shortId: json['shortId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Phigros 游戏存档
class PhigrosGameSave {
  final String objectId;
  final String name;
  final String summary;
  final PhigrosGameFile? gameFile;
  final DateTime? modifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PhigrosGameSave({
    required this.objectId,
    required this.name,
    required this.summary,
    this.gameFile,
    this.modifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhigrosGameSave.fromJson(Map<String, dynamic> json) {
    return PhigrosGameSave(
      objectId: json['objectId'] as String,
      name: json['name'] as String,
      summary: json['summary'] as String,
      gameFile: json['gameFile'] != null
          ? PhigrosGameFile.fromJson(json['gameFile'])
          : null,
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(
              (json['modifiedAt'] as Map<String, dynamic>)['iso'] as String,
            )
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// 解析 summary 数据
  /// 参照 Rust 结构进行解析:
  /// - save_version: u8
  /// - challenge_mode_rank: u16
  /// - rks: f32
  /// - game_version: VarInt
  /// - avatar: PhiString
  /// - level: MultiLevel (ez, hd, in, at 各包含 clear, fc, phi)
  Map<String, dynamic> parseSummary() {
    try {
      // Base64 解码
      final bytes = base64.decode(summary);
      final data = ByteData.sublistView(Uint8List.fromList(bytes));
      int offset = 0;

      // 1. save_version: u8
      final saveVersion = data.getUint8(offset);
      offset += 1;

      // 2. challenge_mode_rank: u16
      final challengeModeRank = data.getUint16(offset, Endian.little);
      offset += 2;

      // 3. rks: f32
      final rks = data.getFloat32(offset, Endian.little);
      offset += 4;

      // 4. game_version: VarInt
      final gameVersionRes = _decodeVarint(bytes, offset);
      final gameVersion = gameVersionRes['value']!;
      offset = gameVersionRes['offset']!;

      // 5. avatar: PhiString
      final avatarRes = _decodePhiString(bytes, offset);
      final avatarName = avatarRes['value'] as String;
      offset = avatarRes['offset'] as int;

      // 6. level: MultiLevel (12 * u16 = 24 bytes)
      // 结构: ez(clear, fc, phi), hd(clear, fc, phi), in(clear, fc, phi), at(clear, fc, phi)
      final levelRecords = <int>[];
      for (int i = 0; i < 12; i++) {
        levelRecords.add(data.getUint16(offset, Endian.little));
        offset += 2;
      }

      return {
        'saveVersion': saveVersion,
        'challengeModeRank': challengeModeRank,
        'rks': rks,
        'gameVersion': gameVersion,
        'avatarName': avatarName,
        'levelRecords': levelRecords,
      };
    } catch (e) {
      print('❌ 解析 summary 失败: $e');
      rethrow;
    }
  }

  /// 解码 PhiString 格式 (VarInt 长度 + UTF-8 字节)
  Map<String, dynamic> _decodePhiString(List<int> bytes, int offset) {
    final lengthRes = _decodeVarint(bytes, offset);
    final length = lengthRes['value']!;
    final currentOffset = lengthRes['offset']!;

    if (currentOffset + length > bytes.length) {
      throw Exception('PhiString 解析错误: 数据长度不足');
    }

    final stringBytes = bytes.sublist(currentOffset, currentOffset + length);
    final value = utf8.decode(stringBytes);

    return {'value': value, 'offset': currentOffset + length};
  }

  /// 解码 varint 格式的整数
  ///
  /// Varint 是一种可变长度编码方式:
  /// - 每个字节的最高位（MSB）用于指示是否还有更多字节
  /// - 如果 MSB 为 1，表示后面还有字节
  /// - 如果 MSB 为 0，表示这是最后一个字节
  /// - 剩余的 7 位用于存储实际数据
  ///
  /// 返回包含解码后的值和新的偏移量
  Map<String, int> _decodeVarint(List<int> bytes, int offset) {
    int value = 0;
    int shift = 0;
    int currentOffset = offset;

    while (true) {
      if (currentOffset >= bytes.length) {
        throw Exception('Varint 解码失败: 数据不完整');
      }

      final byte = bytes[currentOffset];
      currentOffset++;

      // 提取低 7 位并添加到结果中
      value |= (byte & 0x7F) << shift;

      // 如果最高位为 0，说明这是最后一个字节
      if ((byte & 0x80) == 0) {
        break;
      }

      shift += 7;

      // 防止无限循环或溢出
      if (shift > 63) {
        throw Exception('Varint 解码失败: 值过大');
      }
    }

    return {'value': value, 'offset': currentOffset};
  }
}

/// Phigros 游戏文件
class PhigrosGameFile {
  final String objectId;
  final String name;
  final String url;
  final String? mimeType;
  final int? size;

  PhigrosGameFile({
    required this.objectId,
    required this.name,
    required this.url,
    this.mimeType,
    this.size,
  });

  factory PhigrosGameFile.fromJson(Map<String, dynamic> json) {
    return PhigrosGameFile(
      objectId: json['objectId'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      mimeType: json['mime_type'] as String?,
      size: json['metaData'] != null
          ? (json['metaData'] as Map<String, dynamic>)['size'] as int?
          : null,
    );
  }
}
