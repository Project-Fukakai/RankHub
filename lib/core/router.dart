import 'package:go_router/go_router.dart';
import 'package:rank_hub/core/navigation_keys.dart';
import 'package:rank_hub/pages/v2/main_page_v2.dart';

import 'package:rank_hub/games/maimai/views/lxns_login_page.dart';
import 'package:rank_hub/games/maimai/views/divingfish_login_page.dart';

/// GoRouter 配置
final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: mainBranchNavigatorKey,
  routes: [
    GoRoute(
      path: '/login/lxns',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LxnsLoginPage()),
    ),
    GoRoute(
      path: '/login/divingfish',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: DivingFishLoginPage()),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: MainPageV2(detailNavigatorKey: detailBranchNavigatorKey),
      ),
    ),
  ],
);
