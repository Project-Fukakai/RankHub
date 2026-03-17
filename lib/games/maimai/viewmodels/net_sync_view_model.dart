import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/resource_provider.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/games/maimai/maimai_resources.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/net_score.dart';
import 'package:rank_hub/games/maimai/models/maimai_song_catalog.dart';
import 'package:rank_hub/games/maimai/services/net_sync_helper.dart';
import 'package:rank_hub/games/maimai/states/net_sync_state.dart';

/// NET数据同步 ViewModel
/// 管理从 maimai NET 同步成绩到查分器的流程
class NetSyncViewModel extends Notifier<NetSyncState> {
  @override
  NetSyncState build() {
    return const NetSyncState();
  }

  /// 设置输入内容
  void setInput(String input) {
    state = state.copyWith(input: input);
  }

  /// 通过 QR Code 获取用户信息
  Future<void> fetchUserByQrCode() async {
    final qrCode = state.input.trim();
    if (qrCode.isEmpty) {
      state = state.copyWith(errorMessage: '请输入 QR Code');
      return;
    }

    // 验证 QR Code 格式
    if (!qrCode.startsWith('SGWCMAID')) {
      state = state.copyWith(
        errorMessage: 'QR Code 格式不正确，必须以 SGWCMAID 开头',
      );
      return;
    }

    await _fetchUserByQrCode(qrCode);
  }

  /// 通过QR Code获取用户
  Future<void> _fetchUserByQrCode(String qrCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final netUser = await ref.read(
        resourceProviderOf(maimaiNetUserPreviewKey(qrCode)).future,
      );

      state = state.copyWith(
        selectedNetUser: netUser,
        currentQrCode: qrCode,
        currentStep: NetSyncStep.preview,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '获取用户信息失败: $e',
      );
    }
  }

  /// 开始同步成绩到查分器
  Future<void> startSync() async {
    final user = state.selectedNetUser;
    if (user == null) return;

    final qrCode = state.currentQrCode;
    if (qrCode == null || qrCode.isEmpty) {
      state = state.copyWith(
        errorMessage: '请使用QR Code方式获取用户信息以进行同步',
      );
      return;
    }

    final accountState = ref.read(accountViewModelProvider);
    final account = accountState.currentAccount;

    if (account == null) {
      state = state.copyWith(
        errorMessage: '未找到当前账号，请先登录',
      );
      return;
    }

    state = state.copyWith(
      currentStep: NetSyncStep.syncing,
      isLoading: true,
      syncProgress: 0.0,
      syncMessage: '正在从NET获取成绩...',
      syncedScoreCount: 0,
      errorMessage: null,
    );

    try {
      // 检查访问令牌
      final accessToken = account.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('访问令牌不存在，请重新登录');
      }

      await ref.read(
        refreshResourceProviderOf<MaimaiSongCatalog>(
          maimaiSongCatalogResourceKey,
        ).future,
      );

      final songs = await ref.read(
        resourceProviderOf<List<MaimaiSong>>(maimaiSongListResourceKey).future,
      );

      final existingSongIds = songs.map((song) => song.songId).toSet();

      final netScores = await ref.read(
        resourceProviderOf<List<NetScore>>(maimaiNetUserScoresKey(qrCode)).future,
      );

      // 使用统一的同步逻辑
      await NetSyncHelper.syncNetScoresToLxns(
        netScores: netScores,
        existingSongIds: existingSongIds,
        songs: songs,
        lxnsToken: accessToken,
        onProgress: (progress, message, count) {
          state = state.copyWith(
            syncProgress: progress,
            syncMessage: message,
            syncedScoreCount: count,
          );
        },
      );

      state = state.copyWith(
        currentStep: NetSyncStep.success,
        isLoading: false,
        syncMessage: '同步完成',
      );
    } catch (e) {
      state = state.copyWith(
        currentStep: NetSyncStep.error,
        isLoading: false,
        syncMessage: '同步失败: $e',
        errorMessage: '$e',
      );
    }
  }

  /// 返回输入界面
  void backToInput() {
    state = const NetSyncState();
  }
}

/// Provider for NetSyncViewModel
final netSyncViewModelProvider = NotifierProvider.autoDispose<NetSyncViewModel,
    NetSyncState>(
  NetSyncViewModel.new,
);
