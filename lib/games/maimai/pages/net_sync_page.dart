import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rank_hub/core/account.dart';
import 'package:rank_hub/games/maimai/states/net_sync_state.dart';
import 'package:rank_hub/games/maimai/viewmodels/net_sync_view_model.dart';

/// NET数据同步页面
class NetSyncPage extends ConsumerWidget {
  final Account account;

  const NetSyncPage({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(netSyncViewModelProvider);
    final viewModel = ref.read(netSyncViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('从NET同步成绩')),
      body: _buildBody(context, state, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, NetSyncState state, NetSyncViewModel viewModel) {
    switch (state.currentStep) {
      case NetSyncStep.input:
        return _buildInputStep(context, state, viewModel);
      case NetSyncStep.preview:
        return _buildPreviewStep(context, state, viewModel);
      case NetSyncStep.syncing:
        return _buildSyncingStep(context, state);
      case NetSyncStep.success:
        return _buildSuccessStep(context, state, viewModel);
      case NetSyncStep.error:
        return _buildErrorStep(context, state, viewModel);
    }
  }

  /// 输入步骤
  Widget _buildInputStep(BuildContext context, NetSyncState state, NetSyncViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 二维码获取提示
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '如何获取二维码',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. 在微信中打开「舞萌｜中二」公众号\n'
                    '2. 点击「玩家二维码」\n'
                    '3. 打开得到的链接，长按识别二维码\n'
                    '4. 完整地复制识别到的字符串',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // QR Code 输入框
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.qr_code, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        '输入 QR Code',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '格式：SGWCMAID 开头的字符串',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => viewModel.setInput(value),
                    decoration: InputDecoration(
                      hintText: '粘贴 QR Code 内容',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.content_paste),
                        onPressed: () async {
                          final data = await Clipboard.getData(
                            Clipboard.kTextPlain,
                          );
                          final text = data?.text?.trim() ?? '';
                          if (text.isEmpty) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('剪贴板为空')),
                              );
                            }
                            return;
                          }
                          viewModel.setInput(text);
                        },
                      ),
                    ),
                    maxLines: 3,
                  ),
                  if (state.errorMessage != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error))
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : viewModel.fetchUserByQrCode,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('获取用户信息'),
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

  /// 预览步骤
  Widget _buildPreviewStep(BuildContext context, NetSyncState state, NetSyncViewModel viewModel) {
    final user = state.selectedNetUser;
    if (user == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      user.userName.isNotEmpty ? user.userName[0] : 'U',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.userName.isNotEmpty
                        ? user.userName
                        : 'User ${user.userId}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'User ID: ${user.userId}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildInfoRow('Rating', user.playerRating.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 查分器账号信息
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 20,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '将同步到以下账号',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '查分器账号：',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      Expanded(
                        child: Text(
                          account.resolvedDisplayName ?? '未知',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '请确认账号无误后再同步',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: viewModel.startSync,
            icon: const Icon(Icons.cloud_upload),
            label: const Text('确认并开始同步'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: viewModel.backToInput,
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// 同步中步骤
  Widget _buildSyncingStep(BuildContext context, NetSyncState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: state.syncProgress,
            ),
            const SizedBox(height: 24),
            Text(
              state.syncMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              '${(state.syncProgress * 100).toInt()}%',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  /// 成功步骤
  Widget _buildSuccessStep(BuildContext context, NetSyncState state, NetSyncViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              '同步成功！',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '已同步 ${state.syncedScoreCount} 条成绩',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('完成'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: viewModel.backToInput,
              child: const Text('继续同步其他用户'),
            ),
          ],
        ),
      ),
    );
  }

  /// 错误步骤
  Widget _buildErrorStep(BuildContext context, NetSyncState state, NetSyncViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              '同步失败',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              state.syncMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: viewModel.backToInput,
              child: const Text('返回重试'),
            ),
          ],
        ),
      ),
    );
  }
}
