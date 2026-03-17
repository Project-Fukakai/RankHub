import 'package:flutter/material.dart';
import 'package:rank_hub/core/page_descriptor.dart';
import 'package:rank_hub/core/data_definition.dart';

class GameDescriptor {
  final List<PageDescriptor> libraryPages;
  final List<PageDescriptor> scorePages;
  final List<PageDescriptor> toolboxPages;
  final List<PageDescriptor> profilePages;

  final List<GameResourceDefinition> resources;
  final List<GameToolDefinition> tools;

  /// 游戏图标 URL（网络图标）
  final String? iconUrl;

  /// 游戏本地图标
  final IconData? iconData;

  /// 游戏主题色
  final Color? themeColor;

  /// 支持的平台 ID 列表（用于快速查询）
  final List<String> supportedPlatformIds;

  const GameDescriptor({
    required this.libraryPages,
    required this.scorePages,
    required this.toolboxPages,
    required this.profilePages,
    required this.resources,
    required this.tools,
    this.iconUrl,
    this.iconData,
    this.themeColor,
    this.supportedPlatformIds = const [],
  });
}
