import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:rank_hub/models/account/account.dart';
import 'package:rank_hub/services/platform_login_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'phigros_api_service.dart';
import 'taptap_service.dart';

/// Phigros平台登录处理器
class PhigrosLoginHandler extends PlatformLoginHandler {
  final PhigrosApiService _apiService = PhigrosApiService.instance;
  @override
  Platform get platform => Platform.phigros;

  @override
  String get platformName => 'Phigros';

  @override
  IconData get platformIcon => Icons.stars_outlined;

  @override
  String? get platformIconUrl =>
      'https://img.tapimg.com/market/images/9000b8b031deabbd424b7f2f530ee162.png';

  @override
  String get platformDescription => 'Phigros 账号绑定';

  @override
  Future<PlatformLoginResult?> showLoginPage(BuildContext context) async {
    return await Navigator.push<PlatformLoginResult>(
      context,
      MaterialPageRoute(
        builder: (context) => const _PhigrosLoginPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Future<bool> validateCredentials(Map<String, dynamic> credentialData) async {
    final sessionToken = credentialData['api_key'] as String?;
    if (sessionToken == null || sessionToken.isEmpty) {
      return false;
    }

    try {
      return await _apiService.validateSessionToken(sessionToken);
    } catch (e) {
      print('验证Session Token失败: $e');
      return false;
    }
  }

  @override
  Future<PlatformAccountInfo?> fetchAccountInfo(
    Map<String, dynamic> credentialData,
  ) async {
    final sessionToken = credentialData['api_key'] as String?;
    if (sessionToken == null || sessionToken.isEmpty) {
      return null;
    }

    try {
      final userInfo = await _apiService.getUserInfo(sessionToken);
      return PlatformAccountInfo(
        externalId: userInfo.objectId,
        displayName: userInfo.nickname,
        avatarUrl: userInfo.avatar,
      );
    } catch (e) {
      print('获取账号信息失败: $e');
      return null;
    }
  }
}

/// Phigros 登录页面（支持二维码和Session Token）
class _PhigrosLoginPage extends StatefulWidget {
  const _PhigrosLoginPage();

  @override
  State<_PhigrosLoginPage> createState() => _PhigrosLoginPageState();
}

class _PhigrosLoginPageState extends State<_PhigrosLoginPage> {
  int _selectedTab = 0; // 0: 二维码登录, 1: Session Token登录

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phigros 账号绑定')),
      body: Column(
        children: [
          // Tab 选择器
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('扫码登录'),
                  icon: Icon(Icons.qr_code_scanner),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Token登录'),
                  icon: Icon(Icons.vpn_key),
                ),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedTab = newSelection.first;
                });
              },
            ),
          ),
          // 内容区域
          Expanded(
            child: _selectedTab == 0
                ? const _QRCodeLoginTab()
                : const _SessionTokenLoginTab(),
          ),
        ],
      ),
    );
  }
}

/// 二维码登录标签页
class _QRCodeLoginTab extends StatefulWidget {
  const _QRCodeLoginTab();

  @override
  State<_QRCodeLoginTab> createState() => _QRCodeLoginTabState();
}

class _QRCodeLoginTabState extends State<_QRCodeLoginTab> {
  final ShareClient _shareClient = ShareClient();
  String? _qrcodeUrl;
  String? _deviceCode;
  String? _userCode;
  String? _deviceId;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _initializeQRCode();
  }

  Future<void> _initializeQRCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 获取设备信息
      final deviceInfo = DeviceInfoPlugin();
      String deviceId;

      if (io.Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = '${androidInfo.brand} ${androidInfo.model}';
      } else if (io.Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.model;
      } else {
        deviceId = 'Unknown Device';
      }

      // 发起登录，获取二维码
      final loginData = await _shareClient.login(deviceId);

      print('✅ 获取二维码登录数据: $loginData');

      setState(() {
        _qrcodeUrl = loginData['qrcode_url'];
        _deviceCode = loginData['device_code'];
        _userCode = loginData['user_code'];
        _deviceId = deviceId;
        _isLoading = false;
      });

      // 开始轮询
      _startPolling();
    } catch (e) {
      setState(() {
        _errorMessage = '获取二维码失败: $e';
        _isLoading = false;
      });
    }
  }

  void _startPolling() async {
    if (_isPolling || _deviceCode == null || _deviceId == null) return;

    setState(() => _isPolling = true);

    try {
      // 开始轮询获取 sessionToken
      final sessionToken = await _shareClient.getSessionToken(
        _deviceCode!,
        _deviceId!,
      );

      if (!mounted) return;

      // 验证并获取用户信息
      final apiService = PhigrosApiService.instance;
      final userInfo = await apiService.getUserInfo(sessionToken);

      if (!mounted) return;

      // 返回登录结果
      Navigator.of(context).pop(
        PlatformLoginResult(
          externalId: userInfo.objectId,
          credentialData: {'api_key': sessionToken},
          displayName: userInfo.nickname,
          avatarUrl: userInfo.avatar,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              '登录失败: ${e.toString().replaceFirst('Exception: ', '')}';
          _isPolling = false;
        });
      }
    }
  }

  Future<void> _launchTapTap() async {
    final code = _userCode ?? _deviceCode;
    if (code == null) return;

    final url =
        'taptap://taptap.com/login-auth?url=https%3A%2F%2Faccounts.taptap.cn%2Fdevice%3Fqrcode%3D1%26user_code%3D$code%26opener%3Dweb&sess_id=undefined';

    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('未找到 TapTap 客户端')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('打开 TapTap 失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage != null)
                Column(
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[300]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _initializeQRCode,
                      icon: const Icon(Icons.refresh),
                      label: const Text('重试'),
                    ),
                  ],
                )
              else if (_qrcodeUrl != null)
                Column(
                  children: [
                    Text(
                      '使用 TapTap 扫描二维码',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    // 显示二维码
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: _qrcodeUrl!,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 打开 TapTap 一键登录按钮
                    FilledButton.icon(
                      onPressed: _launchTapTap,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('打开 TapTap 一键登录'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF00CCCC), // TapTap 品牌色
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isPolling)
                      Column(
                        children: [
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '等待扫码授权...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    // 帮助说明
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.help_outline, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '如何使用？',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '1. 点击上方「打开 TapTap 一键登录」\n'
                              '2. 或使用 TapTap 扫描上方二维码\n'
                              '3. 在 TapTap 中确认授权',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Session Token 登录标签页
class _SessionTokenLoginTab extends StatefulWidget {
  const _SessionTokenLoginTab();

  @override
  State<_SessionTokenLoginTab> createState() => _SessionTokenLoginTabState();
}

class _SessionTokenLoginTabState extends State<_SessionTokenLoginTab> {
  final _sessionTokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sessionToken = _sessionTokenController.text.trim();
      final apiService = PhigrosApiService.instance;

      // 验证 Session Token 并获取用户信息
      final userInfo = await apiService.getUserInfo(sessionToken);

      if (!mounted) return;

      // 返回登录结果
      Navigator.of(context).pop(
        PlatformLoginResult(
          externalId: userInfo.objectId,
          credentialData: {'api_key': sessionToken},
          displayName: userInfo.nickname,
          avatarUrl: userInfo.avatar,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _sessionTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '使用 Session Token\n绑定账号',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 64),

              // Session Token 输入框
              TextFormField(
                controller: _sessionTokenController,
                decoration: InputDecoration(
                  labelText: 'Session Token',
                  hintText: '粘贴您的 Session Token',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _errorMessage,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入 Session Token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 登录按钮
              FilledButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('绑定账号', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),

              // 帮助说明
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '如何获取 Session Token？',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '1. 使用抓包工具（如 HttpCanary）监听网络请求\n'
                        '2. 在 Phigros 中登录并同步数据\n'
                        '3. 在抓包记录中找到请求头\n'
                        '4. 复制 "X-LC-Session" 字段的值',
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '⚠️ 请勿泄露您的 Session Token',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
