import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rank_hub/core/credential.dart';
import 'package:rank_hub/core/login_provider.dart';
import 'package:rank_hub/core/services/core_log_service.dart';
import 'package:rank_hub/utils/pkce_helper.dart';
import 'package:rank_hub/platforms/maimai/lxns_platform.dart';

class LxnsLoginPage extends StatefulWidget {
  const LxnsLoginPage({super.key});

  @override
  State<LxnsLoginPage> createState() => _LxnsLoginPageState();
}

class _LxnsLoginPageState extends State<LxnsLoginPage> {
  bool _isLoading = false;
  final LxnsPlatform _platform = LxnsPlatform.instance;

  static const String backgroundUrl = 'https://maimai.lxns.net/logo_background.webp';
  static const String foregroundUrl = 'https://maimai.lxns.net/logo_foreground.webp';

  @override
  void dispose() {
    super.dispose();
  }

  /// 开始 OAuth2 登录流程
  Future<void> _startOAuth2Login() async {
    setState(() => _isLoading = true);

    try {
      // 生成 PKCE 参数
      final pkcePair = PkceHelper.generatePkcePair();
      final codeVerifier = pkcePair['code_verifier']!;
      final codeChallenge = pkcePair['code_challenge']!;

      // 生成随机 state 用于防止 CSRF 攻击
      final state = DateTime.now().millisecondsSinceEpoch.toString();

      // 构建授权 URL
      final authUrl =
          '${LxnsPlatform.baseUrl}/oauth/authorize?'
          'response_type=code&'
          'client_id=${LxnsPlatform.clientId}&'
          'redirect_uri=${Uri.encodeComponent(LxnsPlatform.redirectUri)}&'
          'scope=${Uri.encodeComponent(LxnsPlatform.scope)}&'
          'code_challenge=$codeChallenge&'
          'code_challenge_method=S256&'
          'state=$state';

      CoreLogService.i(
        '开始 OAuth2 授权...',
        scope: 'MAIMAI',
        platform: 'LXNS',
      );
      
      // 使用 flutter_web_auth 打开授权页面
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'rankhub',
      );

      // 解析回调 URL
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      final returnedState = uri.queryParameters['state'];

      if (code == null) {
        throw Exception('未收到授权码');
      }

      // 验证 state
      if (returnedState != state) {
        throw Exception('State 验证失败');
      }

      // 使用授权码交换 token
      final tokenData = await _platform.exchangeCodeForToken(code, codeVerifier);
      if (tokenData == null) {
        throw Exception('交换 token 失败');
      }

      await _finishLogin(tokenData);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  /// 开始手动授权码登录流程
  Future<void> _startManualLogin() async {
    setState(() => _isLoading = true);

    try {
      // 生成 PKCE 参数
      final pkcePair = PkceHelper.generatePkcePair();
      final codeVerifier = pkcePair['code_verifier']!;
      final codeChallenge = pkcePair['code_challenge']!;

      // 生成随机 state
      final state = DateTime.now().millisecondsSinceEpoch.toString();

      // 构建授权 URL
      final authUrl =
          '${LxnsPlatform.baseUrl}/oauth/authorize?'
          'response_type=code&'
          'client_id=${LxnsPlatform.manualClientId}&'
          'redirect_uri=${Uri.encodeComponent(LxnsPlatform.manualRedirectUri)}&'
          'scope=${Uri.encodeComponent(LxnsPlatform.scope)}&'
          'code_challenge=$codeChallenge&'
          'code_challenge_method=S256&'
          'state=$state';

      // 导航到手动授权页面获取 code
      final code = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => _ManualAuthPage(authUrl: authUrl),
          fullscreenDialog: true,
        ),
      );

      if (code == null || code.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      // 使用授权码交换 token
      final tokenData = await _platform.exchangeCodeForTokenManual(code, codeVerifier);
      if (tokenData == null) {
        throw Exception('交换 token 失败');
      }

      await _finishLogin(tokenData);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _finishLogin(Map<String, dynamic> tokenData) async {
    // 获取账号信息
    final accountInfo = await _platform.fetchAccountInfo(tokenData['access_token']);
    if (accountInfo == null) {
      throw Exception('获取账号信息失败');
    }

    final userId = accountInfo['id'];
    final userName = accountInfo['name'];
    
    // 创建 Account 对象
    // 注意：Account 是不可变的，我们这里创建一个新的 Account 对象返回
    final expiresAt = tokenData['token_expiry'] != null
        ? DateTime.tryParse(tokenData['token_expiry'] as String)
        : null;
    final credential = JwtCredential(
      token: tokenData['access_token'] as String,
      refreshToken: tokenData['refresh_token'] as String?,
      expiresAt: expiresAt,
    );

    final credentialData = credential.toJson()
      ..['access_token'] = tokenData['access_token']
      ..['scope'] = tokenData['scope']
      ..['token_expiry'] = tokenData['token_expiry'];

    if (mounted) {
      Navigator.pop(
        context,
        PlatformLoginResult(
          externalId: userId.toString(),
          credentialData: credentialData,
          displayName: userName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('落雪咖啡屋登录')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: backgroundUrl,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.coffee,
                                size: 64,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: foregroundUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '落雪咖啡屋',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '使用 OAuth2 安全授权登录',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _startOAuth2Login,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.login),
                    label: Text(_isLoading ? '登录中...' : '自动跳转登录'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _startManualLogin,
                    icon: const Icon(Icons.edit),
                    label: const Text('手动输入授权码'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualAuthPage extends StatefulWidget {
  final String authUrl;

  const _ManualAuthPage({required this.authUrl});

  @override
  State<_ManualAuthPage> createState() => _ManualAuthPageState();
}

class _ManualAuthPageState extends State<_ManualAuthPage> {
  final TextEditingController _codeController = TextEditingController();
  final ChromeSafariBrowser _browser = ChromeSafariBrowser();
  bool _browserOpened = false;

  @override
  void dispose() {
    _codeController.dispose();
    _browser.close();
    super.dispose();
  }

  Future<void> _openBrowser() async {
    if (_browserOpened) return;

    setState(() => _browserOpened = true);

    try {
      try {
        await _browser.open(
          url: WebUri(widget.authUrl),
          settings: ChromeSafariBrowserSettings(
            shareState: CustomTabsShareState.SHARE_STATE_OFF,
            barCollapsingEnabled: true,
          ),
        );
      } on PlatformException catch (e) {
        CoreLogService.w(
          'ChromeSafariBrowser 打开失败: $e',
          scope: 'MAIMAI',
          platform: 'LXNS',
        );
        final Uri authUri = Uri.parse(widget.authUrl);
        if (await canLaunchUrl(authUri)) {
          await launchUrl(authUri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('无法打开浏览器，请检查 URL')),
            );
          }
          setState(() => _browserOpened = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('打开浏览器失败: $e')),
        );
      }
      setState(() => _browserOpened = false);
    }
  }

  void _submitCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入授权码')),
      );
      return;
    }
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('授权登录')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            FilledButton.icon(
              onPressed: _browserOpened ? null : _openBrowser,
              icon: Icon(_browserOpened ? Icons.check : Icons.open_in_browser),
              label: Text(_browserOpened ? '浏览器已打开' : '打开浏览器授权'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: '授权码',
                hintText: '请输入或粘贴授权码',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitCode,
              child: const Text('确认登录'),
            ),
          ],
        ),
      ),
    );
  }
}
