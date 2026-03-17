import 'package:flutter/material.dart';
import 'package:rank_hub/models/account/account.dart';

/// 平台登录处理器抽象接口
/// 每个平台实现自己的登录逻辑和UI
abstract class PlatformLoginHandler {
  /// 平台标识
  Platform get platform;

  /// 平台名称
  String get platformName;

  /// 平台图标
  IconData get platformIcon;

  /// 平台图标 URL (可选)
  /// 如果提供网络图标URL,优先使用网络图标
  String? get platformIconUrl => null;

  /// 平台描述
  String get platformDescription;

  /// 是否支持该平台
  bool get isSupported => true;

  /// 构建登录页面 Widget
  Widget buildLoginPage(BuildContext context);

  /// 显示登录页面
  /// 返回登录结果,包含账号信息和凭据数据
  Future<PlatformLoginResult?> showLoginPage(BuildContext context) async {
    final isWide = MediaQuery.of(context).size.width > 640;
    if (isWide) {
      return await showModalBottomSheet<PlatformLoginResult>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        constraints: const BoxConstraints(maxWidth: 640),
        builder:
            (context) => ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: buildLoginPage(context),
              ),
            ),
      );
    }

    return await Navigator.push<PlatformLoginResult>(
      context,
      MaterialPageRoute(
        builder: (context) => buildLoginPage(context),
        fullscreenDialog: true,
      ),
    );
  }

  /// 验证凭据是否有效
  /// 用于在绑定前验证用户输入的凭据
  Future<bool> validateCredentials(Map<String, dynamic> credentialData);

  /// 获取账号信息
  /// 通过凭据获取账号的详细信息(如用户名、头像等)
  Future<PlatformAccountInfo?> fetchAccountInfo(
    Map<String, dynamic> credentialData,
  );

  /// 刷新凭据(可选)
  /// 对于需要定期刷新的凭据(如OAuth2),实现此方法
  Future<Map<String, dynamic>?> refreshCredentials(
    Map<String, dynamic> oldCredentialData,
  ) async {
    return null; // 默认不需要刷新
  }

  /// 撤销凭据(可选)
  /// 在解绑账号时调用,用于清理平台侧的授权
  Future<void> revokeCredentials(Map<String, dynamic> credentialData) async {
    // 默认不执行任何操作
  }
}

/// 平台登录结果
class PlatformLoginResult {
  /// 外部账号ID(平台的唯一标识)
  final String externalId;

  /// 凭据数据(如API Key、OAuth2 Token等)
  final Map<String, dynamic> credentialData;

  /// 显示名称(可选)
  final String? displayName;

  /// 头像URL(可选)
  final String? avatarUrl;

  /// 其他元数据(可选)
  final Map<String, dynamic>? metadata;

  PlatformLoginResult({
    required this.externalId,
    required this.credentialData,
    this.displayName,
    this.avatarUrl,
    this.metadata,
  });
}

/// 平台账号信息
class PlatformAccountInfo {
  /// 外部账号ID
  final String externalId;

  /// 显示名称
  final String? displayName;

  /// 头像URL
  final String? avatarUrl;

  /// 其他元数据
  final Map<String, dynamic>? metadata;

  PlatformAccountInfo({
    required this.externalId,
    this.displayName,
    this.avatarUrl,
    this.metadata,
  });
}
