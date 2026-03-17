import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rank_hub/controllers/main_controller.dart';
import 'package:rank_hub/controllers/theme_controller.dart';
import 'package:rank_hub/pages/wiki.dart';
import 'package:rank_hub/pages/rank.dart';
import 'package:rank_hub/pages/toolbox.dart';
import 'package:rank_hub/pages/community.dart';
import 'package:rank_hub/pages/mine.dart';
import 'dart:ui';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 640;

        return Obx(() {
          final isCommunity = controller.currentIndex.value == 0;
          final effectiveTheme = isCommunity
              ? themeController.getDarkTheme()
              : Theme.of(context);

          final body = AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.995,
                    end: 1.0,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: IndexedStack(
              key: ValueKey<int>(controller.currentIndex.value),
              index: controller.currentIndex.value,
              children: const [
                CommunityPage(),
                WikiPage(),
                RankPage(),
                ToolboxPage(),
                MinePage(),
              ],
            ),
          );

          return Theme(
            data: effectiveTheme,
            child: Scaffold(
              extendBody: !isWideScreen,
              body: isWideScreen
                  ? Row(
                      children: [
                        NavigationRail(
                          selectedIndex: controller.currentIndex.value,
                          onDestinationSelected: (index) {
                            HapticFeedback.lightImpact();
                            controller.changeTabIndex(index);
                          },
                          labelType: NavigationRailLabelType.all,
                          destinations: const [
                            NavigationRailDestination(
                              icon: Icon(Icons.people_outline),
                              selectedIcon: Icon(Icons.people),
                              label: Text('社区'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.book_outlined),
                              selectedIcon: Icon(Icons.book),
                              label: Text('资料库'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.query_stats_outlined),
                              selectedIcon: Icon(Icons.query_stats),
                              label: Text('成绩'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.construction_outlined),
                              selectedIcon: Icon(Icons.construction),
                              label: Text('工具箱'),
                            ),
                            NavigationRailDestination(
                              icon: Icon(Icons.person_outline),
                              selectedIcon: Icon(Icons.person),
                              label: Text('我的'),
                            ),
                          ],
                        ),
                        const VerticalDivider(thickness: 1, width: 1),
                        Expanded(child: body),
                      ],
                    )
                  : body,
              bottomNavigationBar: isWideScreen
                  ? null
                  : ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: NavigationBar(
                          selectedIndex: controller.currentIndex.value,
                          onDestinationSelected: (index) {
                            HapticFeedback.lightImpact();
                            controller.changeTabIndex(index);
                          },
                          backgroundColor: effectiveTheme.colorScheme.surface
                              .withValues(alpha: 0.8),
                          destinations: const [
                            NavigationDestination(
                              icon: Icon(Icons.people_outline),
                              selectedIcon: Icon(Icons.people),
                              label: '社区',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.book_outlined),
                              selectedIcon: Icon(Icons.book),
                              label: '资料库',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.query_stats_outlined),
                              selectedIcon: Icon(Icons.query_stats),
                              label: '成绩',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.construction_outlined),
                              selectedIcon: Icon(Icons.construction),
                              label: '工具箱',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.person_outline),
                              selectedIcon: Icon(Icons.person),
                              label: '我的',
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
      },
    );
  }
}
