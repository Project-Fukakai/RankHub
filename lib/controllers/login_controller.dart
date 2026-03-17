import 'dart:async';
import 'package:get/get.dart';
import 'package:rank_hub/services/rankhub_api_service.dart';

class LoginController extends GetxController {
  final RankHubApiService _apiService = RankHubApiService();

  // Step control
  final RxInt currentStep = 0.obs; // 0: Phone Input, 1: OTP Input

  // Phone Input
  final RxString phoneNumber = ''.obs;
  final RxBool isPhoneValid = false.obs;

  // OTP Input
  final RxString otpCode = ''.obs;
  final RxString sessionId = ''.obs;

  // Timer for resend
  final RxInt countdown = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void validatePhone(String phone) {
    phoneNumber.value = phone;
    // Simple validation: 11 digits starting with 1
    isPhoneValid.value = RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  Future<void> sendSms() async {
    if (!isPhoneValid.value) return;

    isLoading.value = true;
    try {
      final result = await _apiService.sendSmsCode(phoneNumber.value);
      if (result['success'] == true) {
        final data = result['data'];
        sessionId.value = data['sessionId'];
        currentStep.value = 1;
        _startCountdown();
      } else {
        Get.snackbar('错误', result['message'] ?? '发送验证码失败');
      }
    } catch (e) {
      Get.snackbar('错误', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void _startCountdown() {
    countdown.value = 60;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> login() async {
    if (otpCode.value.length != 6) return;

    isLoading.value = true;
    try {
      final result = await _apiService.loginWithSms(
        phoneNumber.value,
        sessionId.value,
        otpCode.value,
      );

      if (result['success'] == true) {
        // Handle successful login
        // TODO: Save token and update global user state
        Get.back();
        Get.snackbar('成功', '登录成功');
      } else {
        Get.snackbar('错误', result['message'] ?? '登录失败');
      }
    } catch (e) {
      Get.snackbar('错误', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    currentStep.value = 0;
    phoneNumber.value = '';
    otpCode.value = '';
    sessionId.value = '';
    isPhoneValid.value = false;
    _timer?.cancel();
  }
}
