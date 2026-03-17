import 'package:flutter/material.dart';

class PageDescriptor {
  final String title;
  final IconData icon;
  final WidgetBuilder builder;

  /// 该页面是否需要登录账号（默认 false）
  /// 未登录时 UI Shell 会显示引导而非空白
  final bool requiresAccount;

  /// AppBar 操作按钮构建器
  final List<Widget> Function(BuildContext)? actionsBuilder;

  /// FAB 构建器
  final Widget Function(BuildContext)? fabBuilder;

  const PageDescriptor({
    required this.title,
    required this.icon,
    required this.builder,
    this.requiresAccount = false,
    this.actionsBuilder,
    this.fabBuilder,
  });
}
