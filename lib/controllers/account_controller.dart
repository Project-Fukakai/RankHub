import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rank_hub/models/account/account.dart';
import 'package:rank_hub/modules/musedash/services/musedash_credential_provider.dart';
import 'package:rank_hub/modules/osu/services/osu_credential_provider.dart';
import 'package:rank_hub/services/account_service.dart';
import 'package:rank_hub/services/log_service.dart';
import 'package:rank_hub/services/platform_login_manager.dart';
import 'package:rank_hub/services/credential_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 账号管理控制器
class AccountController extends GetxController {
  final LogService _logger = LogService.instance;
  final AccountService _accountService = AccountService.instance;
  static const String _currentAccountIdKey = 'current_account_id';

  // ========== 状态管理 ==========
  final _accounts = <Account>[].obs;
  List<Account> get accounts => _accounts;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  // ========== 当前账号 ==========
  final Rx<Account?> _currentAccount = Rx<Account?>(null);
  Account? get currentAccount => _currentAccount.value;
  Rx<Account?> get currentAccountRx => _currentAccount;

  @override
  void onInit() {
    super.onInit();

    // 初始化平台登录管理器
    PlatformLoginManager.instance.initialize();

    // 注册凭据提供者
    _accountService.registerProvider(MuseDashCredentialProvider());
    _accountService.registerProvider(OsuCredentialProvider());

    // 加载账号列表
    loadAccounts();
  }

  /// 加载所有账号
  Future<void> loadAccounts() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final accounts = await _accountService.getAllAccounts();
      _accounts.value = accounts;

      // 从 SharedPreferences 恢复上次选择的账号
      final prefs = await SharedPreferences.getInstance();
      final savedAccountId = prefs.getInt(_currentAccountIdKey);

      if (savedAccountId != null) {
        // 尝试找到保存的账号
        final savedAccount = accounts.firstWhereOrNull(
          (a) => a.id == savedAccountId,
        );
        if (savedAccount != null) {
          _currentAccount.value = savedAccount;
          return;
        }
      }

      // 如果没有当前账号,选择第一个激活的账号
      if (_currentAccount.value == null && accounts.isNotEmpty) {
        _currentAccount.value = accounts.firstWhereOrNull((a) => a.isActive);
        // 保存选择
        if (_currentAccount.value != null) {
          await _saveCurrentAccountId(_currentAccount.value!.id);
        }
      }
    } catch (e) {
      _errorMessage.value = '加载账号失败: $e';
      _logger.error('加载账号失败: $e');
      debugPrintStack(stackTrace: (e as Error).stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 绑定新账号
  Future<bool> bindAccount({
    required Platform platform,
    required String externalId,
    required Map<String, dynamic> credentialData,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final account = await _accountService.bindAccount(
        platform: platform,
        externalId: externalId,
        credentialData: credentialData,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );

      await loadAccounts();

      // 如果是第一个账号,设置为当前账号
      if (_currentAccount.value == null) {
        _currentAccount.value = account;
      }

      Get.snackbar('成功', '账号绑定成功');
      return true;
    } catch (e) {
      _errorMessage.value = '绑定账号失败: $e';
      Get.snackbar('错误', '绑定账号失败: $e');
      _logger.error('绑定账号失败: $e');
      debugPrintStack(stackTrace: (e as Error).stackTrace);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 解绑账号
  Future<bool> unbindAccount(int accountId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _accountService.unbindAccount(accountId);
      await loadAccounts();

      // 如果删除的是当前账号,清空当前账号
      if (_currentAccount.value?.id == accountId) {
        _currentAccount.value = _accounts.firstWhereOrNull((a) => a.isActive);
        await _saveCurrentAccountId(_currentAccount.value?.id);
      }

      Get.snackbar('成功', '账号解绑成功');
      return true;
    } catch (e) {
      _errorMessage.value = '解绑账号失败: $e';
      Get.snackbar('错误', '解绑账号失败: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// 切换当前账号
  Future<void> switchAccount(Account account) async {
    _currentAccount.value = account;
    await _saveCurrentAccountId(account.id);
    Get.snackbar('成功', '已切换到账号: ${account.displayName ?? account.externalId}');
  }

  /// 保存当前账号ID
  Future<void> _saveCurrentAccountId(int? accountId) async {
    final prefs = await SharedPreferences.getInstance();
    if (accountId != null) {
      await prefs.setInt(_currentAccountIdKey, accountId);
    } else {
      await prefs.remove(_currentAccountIdKey);
    }
  }

  /// 设置账号激活状态
  Future<void> setAccountActive(int accountId, bool isActive) async {
    try {
      await _accountService.setAccountActive(accountId, isActive);
      await loadAccounts();
    } catch (e) {
      Get.snackbar('错误', '操作失败: $e');
    }
  }

  /// 获取账号凭据（含自动刷新）
  /// 返回 null 表示凭据失效且需要重新登录
  Future<Account?> getAccountCredential(Account account) async {
    try {
      return await _accountService.getCredential(account);
    } on CredentialExpiredException catch (e) {
      // 凭据已完全失效，需要重新登录
      _logger.warning('凭据失效: $e');
      _showReloginDialog(account);
      return null;
    } catch (e) {
      Get.snackbar('错误', '获取凭据失败: $e');
      return null;
    }
  }

  /// 验证账号凭据
  Future<bool> validateAccount(Account account) async {
    try {
      return await _accountService.validateCredential(account);
    } catch (e) {
      return false;
    }
  }

  /// 获取指定平台的激活账号
  Account? getActivePlatformAccount(Platform platform) {
    return _accounts.firstWhereOrNull(
      (a) => a.platform == platform && a.isActive,
    );
  }

  /// 检查平台是否已绑定
  bool hasPlatformAccount(Platform platform) {
    return _accounts.any((a) => a.platform == platform);
  }

  /// 获取平台账号数量
  int getPlatformAccountCount(Platform platform) {
    return _accounts.where((a) => a.platform == platform).length;
  }

  /// 显示重新登录对话框
  void _showReloginDialog(Account account) {
    Get.dialog(
      AlertDialog(
        title: const Text('凭据已失效'),
        content: Text(
          '账号 "${account.displayName ?? account.externalId}" 的凭据已失效，需要重新登录以继续使用。',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('稍后')),
          FilledButton(
            onPressed: () {
              Get.back();
              reloginAccount(account);
            },
            child: const Text('重新登录'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// 重新登录账号
  Future<bool> reloginAccount(Account account) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // 获取平台的登录处理器
      final loginManager = PlatformLoginManager.instance;
      final handler = loginManager.getHandler(account.platform);

      if (handler == null) {
        throw Exception('不支持的平台: ${account.platform}');
      }

      // 显示登录页面
      final result = await handler.showLoginPage(Get.context!);
      if (result == null) {
        // 用户取消登录
        return false;
      }

      // 验证是否为同一账号
      if (result.externalId != account.externalId) {
        Get.snackbar('错误', '登录的账号与原账号不一致', snackPosition: SnackPosition.BOTTOM);
        return false;
      }

      // 更新账号凭据
      final provider = _accountService.getProvider(account.platform);
      if (provider == null) {
        throw Exception('找不到凭据提供者');
      }

      await provider.createCredential(account, result.credentialData);

      // 更新显示信息
      if (result.displayName != null) {
        account.displayName = result.displayName;
      }
      if (result.avatarUrl != null) {
        account.avatarUrl = result.avatarUrl;
      }

      // 保存更新后的账号
      await _accountService.updateAccount(account);

      // 重新加载账号列表
      await loadAccounts();

      Get.snackbar('成功', '重新登录成功', snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      _errorMessage.value = '重新登录失败: $e';
      Get.snackbar('错误', '重新登录失败: $e', snackPosition: SnackPosition.BOTTOM);
      _logger.error('重新登录失败: $e');
      debugPrintStack(stackTrace: (e as Error).stackTrace);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
