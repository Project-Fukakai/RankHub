import 'package:rank_hub/models/platform.dart';
import 'package:rank_hub/models/account/account.dart' show Platform;
import 'package:rank_hub/modules/musedash/musedash_platform.dart';
import 'package:rank_hub/modules/osu/osu_platform.dart';

/// 平台注册中心
/// 管理所有可用的平台
class PlatformRegistry {
  // 单例模式
  static final PlatformRegistry _instance = PlatformRegistry._internal();
  factory PlatformRegistry() => _instance;
  PlatformRegistry._internal();

  // 所有注册的平台
  final List<IPlatform> _platforms = [
    MuseDashPlatform(),
    OsuPlatform(),
    // 未来可以添加更多平台
    // OtherPlatform(),
  ];

  /// 获取所有平台
  List<IPlatform> getAllPlatforms() => _platforms;

  /// 获取启用的平台
  List<IPlatform> getEnabledPlatforms() {
    return _platforms.where((p) => p.isEnabled).toList();
  }

  /// 获取排序后的平台
  List<IPlatform> getSortedPlatforms() {
    final sorted = List<IPlatform>.from(_platforms);
    sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted;
  }

  /// 根据ID获取平台
  IPlatform? getPlatformById(String id) {
    try {
      return _platforms.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 根据平台类型获取平台
  IPlatform? getPlatformByType(Platform platform) {
    try {
      return _platforms.firstWhere((p) => p.platform == platform);
    } catch (e) {
      return null;
    }
  }

  /// 初始化所有平台
  Future<void> initializeAll() async {
    for (final platform in _platforms) {
      await platform.initialize();
    }
  }

  /// 销毁所有平台
  void disposeAll() {
    for (final platform in _platforms) {
      platform.dispose();
    }
  }
}
