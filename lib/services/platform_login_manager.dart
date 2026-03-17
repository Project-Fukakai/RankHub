import 'package:get/get.dart';
import 'package:rank_hub/models/account/account.dart';
import 'package:rank_hub/modules/musedash/services/musedash_login_handler.dart';
import 'package:rank_hub/modules/osu/services/osu_login_handler.dart';
import 'package:rank_hub/services/platform_login_handler.dart';

/// 平台登录管理器
/// 统一管理各平台的登录处理器
class PlatformLoginManager extends GetxService {
  static PlatformLoginManager? _instance;

  PlatformLoginManager._();

  static PlatformLoginManager get instance {
    _instance ??= PlatformLoginManager._();
    return _instance!;
  }

  /// 所有已注册的登录处理器
  final Map<Platform, PlatformLoginHandler> _handlers = {};

  /// 初始化,注册所有平台的登录处理器
  void initialize() {
    registerHandler(MuseDashLoginHandler());
    registerHandler(OsuLoginHandler());
    // 未来可以继续添加其他平台
  }

  /// 注册登录处理器
  void registerHandler(PlatformLoginHandler handler) {
    _handlers[handler.platform] = handler;
  }

  /// 获取指定平台的登录处理器
  PlatformLoginHandler? getHandler(Platform platform) {
    return _handlers[platform];
  }

  /// 获取所有支持的平台
  List<Platform> getSupportedPlatforms() {
    return _handlers.keys
        .where((platform) => _handlers[platform]!.isSupported)
        .toList();
  }

  /// 获取所有支持的登录处理器
  List<PlatformLoginHandler> getAllHandlers() {
    return _handlers.values.where((handler) => handler.isSupported).toList();
  }

  /// 检查平台是否支持
  bool isPlatformSupported(Platform platform) {
    final handler = _handlers[platform];
    return handler != null && handler.isSupported;
  }
}
