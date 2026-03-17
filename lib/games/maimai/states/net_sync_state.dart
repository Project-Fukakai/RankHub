import 'package:flutter/foundation.dart';
import 'package:techno_kitchen_dart/techno_kitchen_dart.dart';

/// NET同步步骤
enum NetSyncStep {
  input, // 输入QR Code或User ID
  preview, // 预览用户信息
  syncing, // 同步中
  success, // 同步成功
  error, // 同步失败
}

/// NET数据同步状态
@immutable
class NetSyncState {
  final bool isLoading;
  final NetSyncStep currentStep;
  final String input;
  final UserPreview? selectedNetUser;
  final String? currentQrCode;
  final double syncProgress;
  final String syncMessage;
  final int syncedScoreCount;
  final String? errorMessage;

  const NetSyncState({
    this.isLoading = false,
    this.currentStep = NetSyncStep.input,
    this.input = '',
    this.selectedNetUser,
    this.currentQrCode,
    this.syncProgress = 0.0,
    this.syncMessage = '',
    this.syncedScoreCount = 0,
    this.errorMessage,
  });

  NetSyncState copyWith({
    bool? isLoading,
    NetSyncStep? currentStep,
    String? input,
    UserPreview? selectedNetUser,
    String? currentQrCode,
    double? syncProgress,
    String? syncMessage,
    int? syncedScoreCount,
    String? errorMessage,
  }) {
    return NetSyncState(
      isLoading: isLoading ?? this.isLoading,
      currentStep: currentStep ?? this.currentStep,
      input: input ?? this.input,
      selectedNetUser: selectedNetUser ?? this.selectedNetUser,
      currentQrCode: currentQrCode ?? this.currentQrCode,
      syncProgress: syncProgress ?? this.syncProgress,
      syncMessage: syncMessage ?? this.syncMessage,
      syncedScoreCount: syncedScoreCount ?? this.syncedScoreCount,
      errorMessage: errorMessage,
    );
  }
}
