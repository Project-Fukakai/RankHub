import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/pages/community.dart';

/// CommunityPageV2 - 去除 GetX 依赖的社区页面
/// 目前直接复用旧的 CommunityPage，后续可以进一步重构
class CommunityPageV2 extends ConsumerWidget {
  const CommunityPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 暂时直接使用旧的 CommunityPage
    // 因为社区页面不依赖游戏/账号状态，可以保持不变
    return const CommunityPage();
  }
}
