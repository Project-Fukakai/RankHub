import 'package:amap_map/amap_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:phasetida_flutter/phasetida_flutter.dart';
import 'package:rank_hub/core/router.dart';
import 'package:rank_hub/core/bootstrap.dart';
import 'package:rank_hub/core/core_context.dart';
import 'package:rank_hub/core/core_provider.dart';
import 'package:rank_hub/controllers/theme_controller.dart';
import 'package:rank_hub/controllers/account_controller.dart';
import 'package:rank_hub/controllers/game_controller.dart';
import 'package:rank_hub/controllers/main_controller.dart';
import 'package:rank_hub/services/log_service.dart';
import 'package:rank_hub/services/qr_code_scanner_service.dart';
import 'package:rank_hub/services/mai_party_qr_handler.dart';
import 'package:rank_hub/services/queue_status_manager.dart';
import 'package:rank_hub/services/live_activity_service.dart';
import 'package:rank_hub/store/user_store.dart';
import 'package:x_amap_base/x_amap_base.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化新架构的核心服务
  await bootstrapCore();

  // 初始化 UserStore
  await getx.Get.putAsync(() async {
    final store = UserStore();
    await store.init();
    return store;
  });

  // 初始化日志服务
  final logService = LogService.instance;
  logService.initialize();

  // 初始化 Live Activities
  await LiveActivityService.instance.init();

  // 注册二维码处理器
  final qrService = QRCodeScannerService();
  qrService.registerHandler(MaiPartyQRCodeHandler());

  // 初始化排队状态管理器
  getx.Get.put(QueueStatusManager());

  // 初始化 phasetida
  await PhasetidaFlutter.init();

  await FullScreen.ensureInitialized();

  // 注册旧的 GetX Controller（兼容未迁移的页面）
  _registerLegacyControllers();

  final container = ProviderContainer();
  await CoreProvider.instance.initializeAppContext(
    container.read(appContextProvider.notifier),
  );

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

/// 注册旧的 GetX Controller（兼容层）
void _registerLegacyControllers() {
  getx.Get.lazyPut(() => MainController());
  getx.Get.lazyPut(() => AccountController());
  getx.Get.lazyPut(() => GameController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = getx.Get.put(ThemeController());

    AMapInitializer.updatePrivacyAgree(
      AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true),
    );

    AMapInitializer.init(
      context,
      apiKey: AMapApiKey(
        iosKey: '808f8cff67cf6e0af5d1718a9d3b6a6b',
        androidKey: '9d203d41e9a4e6f41f16845a56ccec81',
      ),
    );

    return getx.Obx(
      () => MaterialApp.router(
        title: 'RankHub',
        theme: themeController.getLightTheme(),
        darkTheme: themeController.getDarkTheme(),
        themeMode: themeController.themeMode.value,
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
