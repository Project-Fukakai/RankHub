import 'package:get/get.dart';
import 'package:rank_hub/pages/main_page.dart';
import 'package:rank_hub/pages/nearcade.dart';
import 'package:rank_hub/pages/shop_detail_page.dart';
import 'package:rank_hub/pages/all_shops_page.dart';
import 'package:rank_hub/pages/wiki.dart';
import 'package:rank_hub/pages/rank.dart';
import 'package:rank_hub/pages/mine.dart';
import 'package:rank_hub/pages/detail.dart';
import 'package:rank_hub/pages/settings.dart';
import 'package:rank_hub/pages/theme_settings.dart';
import 'package:rank_hub/pages/notification_settings.dart';
import 'package:rank_hub/pages/privacy_policy.dart';
import 'package:rank_hub/pages/about.dart';
import 'package:rank_hub/pages/log_page.dart';
import 'package:rank_hub/routes/app_routes.dart';
import 'package:rank_hub/controllers/main_controller.dart';
import 'package:rank_hub/controllers/game_controller.dart';
import 'package:rank_hub/controllers/account_controller.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AccountController(), fenix: true);
        Get.lazyPut(() => MainController());
        Get.lazyPut(() => GameController());
      }),
    ),
    GetPage(name: AppRoutes.wiki, page: () => const WikiPage()),
    GetPage(name: AppRoutes.rank, page: () => const RankPage()),
    GetPage(name: AppRoutes.mine, page: () => const MinePage()),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.themeSettings,
      page: () => const ThemeSettingsPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.notificationSettings,
      page: () => const NotificationSettingsPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.logs,
      page: () => const LogPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.nearcade,
      page: () => const NearcadePage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.shopDetail,
      page: () => const ShopDetailPage(),
      transition: Transition.native,
    ),
    GetPage(
      name: AppRoutes.allShops,
      page: () => const AllShopsPage(),
      transition: Transition.native,
    ),
  ];
}
