import 'dart:ui';

import 'package:based_split_view/based_split_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as getx;
import 'package:rank_hub/controllers/theme_controller.dart';
import 'package:rank_hub/core/viewmodels/main_view_model.dart';
import 'package:rank_hub/pages/v2/community_v2.dart';
import 'package:rank_hub/pages/v2/mine_v2.dart';
import 'package:rank_hub/pages/v2/rank_v2.dart';
import 'package:rank_hub/pages/v2/toolbox_v2.dart';
import 'package:rank_hub/pages/v2/wiki_v2.dart';

class MainPageV2 extends ConsumerWidget {
  final GlobalKey<NavigatorState> detailNavigatorKey;

  MainPageV2({
    super.key,
    required this.detailNavigatorKey,
  });

  // Breakpoint constants
  static const double kTwoColumnBreakpoint = 640.0;
  static const double kThreeColumnBreakpoint = 1024.0;

  final GlobalKey _mainPaneKey = GlobalKey();
  static const List<Widget> _pages = [
    CommunityPageV2(),
    WikiPageV2(),
    RankPageV2(),
    ToolboxPageV2(),
    MinePageV2(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainViewModelProvider);
    final themeController = getx.Get.find<ThemeController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < kTwoColumnBreakpoint;
        final isThreeColumn = width >= kThreeColumnBreakpoint;

        return getx.Obx(() {
          final isCommunity = currentIndex == 0;
          final effectiveTheme = isCommunity
              ? themeController.getDarkTheme()
              : Theme.of(context);

          const showNavigation = true;

          return Theme(
            data: effectiveTheme,
            child: Scaffold(
              extendBody: isMobile && showNavigation,
              body: isThreeColumn && showNavigation
                  ? BasedSplitView(
                      navigatorKey: detailNavigatorKey,
                      leftWidget: Row(
                        key: _mainPaneKey,
                        children: [
                          NavigationRail(
                            selectedIndex: currentIndex,
                            onDestinationSelected: (index) {
                              HapticFeedback.lightImpact();
                              _navigateToTab(index, ref);
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
                          Expanded(child: _buildMainContent(currentIndex)),
                        ],
                      ),
                      splitMode: SplitMode.flex,
                      leftFlex: 40,
                      rightFlex: 60,
                      dividerWidth: 1,
                      rightPlaceholder: const DetailEmptyView(),
                    )
                  : (!isMobile && showNavigation
                      ? Row(
                          children: [
                            NavigationRail(
                              selectedIndex: currentIndex,
                              onDestinationSelected: (index) {
                                HapticFeedback.lightImpact();
                                _navigateToTab(index, ref);
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
                            Expanded(child: _buildMainContent(currentIndex)),
                          ],
                        )
                      : _buildMainContent(currentIndex)),
              bottomNavigationBar: isMobile
                  ? TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: showNavigation ? 1 : 0,
                        end: showNavigation ? 1 : 0,
                      ),
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final bottomInset = MediaQuery.of(
                          context,
                        ).padding.bottom;
                        final targetHeight =
                            kBottomNavigationBarHeight + bottomInset;
                        final height = lerpDouble(0, targetHeight, value)!;
                        return SizedBox(
                          height: height,
                          child: value == 0
                              ? const SizedBox.shrink()
                              : Opacity(
                                  opacity: value,
                                  child: IgnorePointer(
                                    ignoring: value < 0.01,
                                    child: ClipRect(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        heightFactor: value,
                                        child: child,
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      },
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: NavigationBar(
                            selectedIndex: currentIndex,
                            onDestinationSelected: (index) {
                              HapticFeedback.lightImpact();
                              _navigateToTab(index, ref);
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
                    )
                  : null,
            ),
          );
        });
      },
    );
  }

  Widget _buildMainContent(int currentIndex) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.995, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: IndexedStack(
        key: ValueKey<int>(currentIndex),
        index: currentIndex,
        children: _pages,
      ),
    );
  }

  void _navigateToTab(int index, WidgetRef ref) {
    ref.read(mainViewModelProvider.notifier).changeTab(index);
  }
}

class DetailEmptyView extends StatelessWidget {
  const DetailEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 20),
          Text(
            '选择一个项目以查看详情',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
