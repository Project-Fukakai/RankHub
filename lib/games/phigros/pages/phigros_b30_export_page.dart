import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/core/viewmodels/account_view_model.dart';
import 'package:rank_hub/games/phigros/viewmodels/phigros_view_model.dart';
import 'package:rank_hub/games/phigros/widgets/phigros_record_card.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/song.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Phigros B30 导出页面
class PhigrosB30ExportPage extends ConsumerStatefulWidget {
  final int ezCount;
  final int ezC;
  final int ezFC;
  final int ezPhi;
  final int hdCount;
  final int hdC;
  final int hdFC;
  final int hdPhi;
  final int inCount;
  final int inC;
  final int inFC;
  final int inPhi;
  final int atCount;
  final int atC;
  final int atFC;
  final int atPhi;
  final int fcCount;
  final int phiCount;
  final int? challengeMode;
  final int? challengeRankLevel;
  final String avatarName;

  const PhigrosB30ExportPage({
    super.key,
    this.ezCount = 0,
    this.ezC = 0,
    this.ezFC = 0,
    this.ezPhi = 0,
    this.hdCount = 0,
    this.hdC = 0,
    this.hdFC = 0,
    this.hdPhi = 0,
    this.inCount = 0,
    this.inC = 0,
    this.inFC = 0,
    this.inPhi = 0,
    this.atCount = 0,
    this.atC = 0,
    this.atFC = 0,
    this.atPhi = 0,
    this.fcCount = 0,
    this.phiCount = 0,
    this.challengeMode,
    this.challengeRankLevel,
    required this.avatarName,
  });

  @override
  ConsumerState<PhigrosB30ExportPage> createState() =>
      _PhigrosB30ExportPageState();
}

class _PhigrosB30ExportPageState
    extends ConsumerState<PhigrosB30ExportPage> {
  final _screenshotController = ScreenshotController();

  PhigrosSong? _backgroundSong;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final account = ref.read(accountViewModelProvider).currentAccount;
      if (account == null) return;
      final viewModel = ref.read(phigrosViewModelProvider.notifier);

      await viewModel.loadRecords();
      await viewModel.loadSongs();

      if (!mounted) return;
      _selectRandomBackground(ref.read(phigrosViewModelProvider).songs);
    });
  }

  void _selectRandomBackground(List<PhigrosSong> songs) {
    if (songs.isNotEmpty) {
      final random = Random();
      setState(() {
        _backgroundSong = songs[random.nextInt(songs.length)];
      });
    }
  }

  Future<void> _shareScreenshot() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      // 提示用户等待图片加载
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正在生成图片，请稍候...（请确保图片已加载完成）'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // 等待一小段时间确保所有图片渲染完成
      await Future.delayed(const Duration(milliseconds: 1500));

      // 生成图片
      final image = await _screenshotController.capture(pixelRatio: 4.0);
      if (image == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('图片生成失败')));
        }
        return;
      }

      // 保存到临时目录
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final username =
          ref.read(accountViewModelProvider).currentAccount?.displayName ??
              'unknown';
      final filePath =
          '${directory.path}/RankHub_B30_${username}_$timestamp.png';

      final file = File(filePath);
      await file.writeAsBytes(image);

      // 分享
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'RankHub B30 成绩分享',
        sharePositionOrigin: Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('分享失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _showBackgroundSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '选择背景',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  onPressed: () {
                    final songs = ref.read(phigrosViewModelProvider).songs;
                    _selectRandomBackground(songs);
                    Navigator.pop(context);
                  },
                  tooltip: '随机选择',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final songs = ref.watch(phigrosViewModelProvider).songs;
                  if (songs.isEmpty) {
                    return const Center(child: Text('暂无歌曲数据'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _backgroundSong = song;
                          });
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: song.illustrationLowResUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey.shade300),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.error),
                                    ),
                              ),
                              Container(
                                color: Colors.black.withValues(alpha: 0.3),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  song.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhigrosDifficulty _getDifficulty(String level) {
    switch (level.toUpperCase()) {
      case 'EZ':
        return PhigrosDifficulty.ez;
      case 'HD':
        return PhigrosDifficulty.hd;
      case 'IN':
        return PhigrosDifficulty.inDiff;
      case 'AT':
        return PhigrosDifficulty.at;
      default:
        return PhigrosDifficulty.hd;
    }
  }

  PhigrosSong? _getSongById(String songId, List<PhigrosSong> songs) {
    for (final song in songs) {
      if (song.songId == songId) return song;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B30 导出'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wallpaper),
            onPressed: _showBackgroundSelector,
            tooltip: '选择背景',
          ),
          if (_isSharing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareScreenshot,
              tooltip: '分享',
            ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(phigrosViewModelProvider);
          final viewModel = ref.read(phigrosViewModelProvider.notifier);
          if (state.isLoadingRecords || state.isLoadingSongs) {
            return const Center(child: CircularProgressIndicator());
          }

          final b30Data = viewModel.getB30Records();
          final phiRecords = b30Data['phi'] ?? [];
          final bestRecords = b30Data['best'] ?? [];
          final songs = state.songs;

          // 合并 Phi 和 Best 记录
          final allB30Records = [...phiRecords, ...bestRecords];

          if (allB30Records.isEmpty) {
            return const Center(child: Text('暂无成绩数据'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Screenshot(
              controller: _screenshotController,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 1200, // 固定宽度，确保布局一致
                  child: Stack(
                    children: [
                      // 背景图片（仅覆盖内容区域）
                      if (_backgroundSong != null)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: _backgroundSong!.illustrationUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey.shade900),
                              errorWidget: (context, url, error) =>
                                  Container(color: Colors.grey.shade900),
                            ),
                          ),
                        ),

                      // 模糊滤镜
                      if (_backgroundSong != null)
                        Positioned.fill(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        ),

                      // 内容
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            // 标题区域
                            _buildHeader(allB30Records),
                            const SizedBox(height: 72),

                            // Phi 区域
                            if (phiRecords.isNotEmpty) ...[
                              _buildSectionTitle(
                                'Phi (P1-P${phiRecords.length})',
                              ),
                              const SizedBox(height: 16),
                              _buildRecordGrid(
                                phiRecords,
                                startIndex: 0,
                                labelPrefix: 'Phi',
                                songs: songs,
                              ),
                              const SizedBox(height: 72),
                            ],

                            // Best 区域
                            if (bestRecords.isNotEmpty) ...[
                              _buildSectionTitle(
                                'Best 27 (B1-B${bestRecords.length})',
                              ),
                              const SizedBox(height: 16),
                              _buildRecordGrid(
                                bestRecords,
                                startIndex: 0,
                                labelPrefix: '#',
                                songs: songs,
                              ),
                            ],

                            // Generate 信息
                            const SizedBox(height: 32),
                            _buildGenerateInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<PhigrosGameRecord> b30Records) {
    // 计算 B30 平均 RKS
    final b30Average = b30Records.isEmpty
        ? 0.0
        : b30Records.map((r) => r.rks).reduce((a, b) => a + b) /
              b30Records.length;

    // 获取头像 URL
    final avatarUrl = widget.avatarName.isNotEmpty
        ? 'https://ghfast.top/https://raw.githubusercontent.com/7aGiven/Phigros_Resource/refs/heads/avatar/${widget.avatarName}.png'
        : '';

    final account = ref.read(accountViewModelProvider).currentAccount;

    // 获取挑战模式等级颜色
    Color getChallengeColor() {
      if (widget.challengeRankLevel == null) return Colors.grey;
      switch (widget.challengeRankLevel!) {
        case 1:
          return Colors.green;
        case 2:
          return Colors.blue;
        case 3:
          return Colors.red;
        case 4:
          return Colors.amber;
        case 5:
          return Colors.purple;
        default:
          return Colors.grey;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 左侧：头像和信息组合
        SizedBox(
          width: 720, // 固定宽度以容纳头像和延伸容器
          height: 140,
          child: Stack(
            children: [
              Positioned(
                left: 200,
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 12,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 左侧：RKS 和课题模式（两行）
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 课题模式（第一行，平行四边形容器）
                            if (widget.challengeMode != null &&
                                widget.challengeMode! > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 64),
                                child: CustomPaint(
                                  painter: ParallelogramBorderPainter(
                                    skew: 8,
                                    color: getChallengeColor(),
                                    borderWidth: 4,
                                  ),
                                  child: ClipPath(
                                    clipper: ParallelogramClipper(skew: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getChallengeColor().withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                      child: Text(
                                        (widget.challengeMode! % 100)
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const Spacer(),
                            // RKS（第二行，平行四边形容器）
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: PhysicalShape(
                                clipper: ParallelogramClipper(skew: 8),
                                color: Colors.white,
                                shadowColor: Colors.black,
                                elevation: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    b30Average.toStringAsFixed(4),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 右侧：用户名
                      Text(
                        account?.displayName ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (avatarUrl.isNotEmpty)
                PhysicalShape(
                  clipper: ParallelogramClipper(skew: 24),
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 8,
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 240,
                    height: 140,
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white54,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Spacer(),
        // 右侧：完成情况统计表格
        CustomPaint(
          painter: ParallelogramLeftBorderPainter(
            skew: 30,
            color: Colors.white,
            borderWidth: 4,
          ),
          child: PhysicalShape(
            clipper: ParallelogramClipper(skew: 30),
            color: Colors.black.withValues(alpha: 0.5),
            shadowColor: Colors.black,
            elevation: 4,
            child: Transform(
              transform: Matrix4.skewX(-0.15),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 48,
                  right: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Table(
                  border: TableBorder.all(color: Colors.transparent, width: 0),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    // 标题行
                    TableRow(
                      children: [
                        const SizedBox(width: 60), // 空白列
                        _buildTableHeader('C'),
                        _buildTableHeader('FC'),
                        _buildTableHeader('Phi'),
                      ],
                    ),
                    // EZ 行
                    TableRow(
                      children: [
                        _buildDifficultyLabel('EZ', Colors.green),
                        _buildStatCell(widget.ezC, widget.ezCount),
                        _buildStatCell(widget.ezFC, widget.ezCount),
                        _buildStatCell(widget.ezPhi, widget.ezCount),
                      ],
                    ),
                    // HD 行
                    TableRow(
                      children: [
                        _buildDifficultyLabel('HD', Colors.blue),
                        _buildStatCell(widget.hdC, widget.hdCount),
                        _buildStatCell(widget.hdFC, widget.hdCount),
                        _buildStatCell(widget.hdPhi, widget.hdCount),
                      ],
                    ),
                    // IN 行
                    TableRow(
                      children: [
                        _buildDifficultyLabel('IN', Colors.red),
                        _buildStatCell(widget.inC, widget.inCount),
                        _buildStatCell(widget.inFC, widget.inCount),
                        _buildStatCell(widget.inPhi, widget.inCount),
                      ],
                    ),
                    // AT 行
                    TableRow(
                      children: [
                        _buildDifficultyLabel('AT', Colors.purple),
                        _buildStatCell(widget.atC, widget.atCount),
                        _buildStatCell(widget.atFC, widget.atCount),
                        _buildStatCell(widget.atPhi, widget.atCount),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultyLabel(String difficulty, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCell(int count, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return PhysicalShape(
      clipper: ParallelogramClipper(skew: 14),
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildRecordGrid(
    List<PhigrosGameRecord> records, {
    required int startIndex,
    required String labelPrefix,
    required List<PhigrosSong> songs,
  }) {
    // 每排3个
    final rows = <Widget>[];

    for (int i = 0; i < records.length; i += 3) {
      final rowRecords = records.sublist(
        i,
        (i + 3 < records.length) ? i + 3 : records.length,
      );

      rows.add(
        _buildRow(
          rowRecords,
          startIndex: startIndex + i,
          labelPrefix: labelPrefix,
          songs: songs,
        ),
      );

      if (i + 3 < records.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(children: rows);
  }

  Widget _buildRow(
    List<PhigrosGameRecord> records, {
    required int startIndex,
    required String labelPrefix,
    required List<PhigrosSong> songs,
  }) {
    return Row(
      children: [
        for (int i = 0; i < records.length; i++) ...[
          Expanded(
            child: Builder(
              builder: (context) {
                final song = _getSongById(records[i].songId, songs);
                final viewModel =
                    ref.read(phigrosViewModelProvider.notifier);

                if (song == null) {
                  return Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text('歌曲未找到')),
                  );
                }

                final record = records[i];
                final difficulty = _getDifficulty(record.level);
                final label = '$labelPrefix${startIndex + i + 1}';
                final requiredAcc = viewModel
                    .calculateRequiredAccForRksIncrease(record, true);

                return PhigrosRecordCard(
                  difficulty: difficulty,
                  song: song,
                  record: record,
                  requiredAcc: requiredAcc,
                  label: label,
                );
              },
            ),
          ),
          if (i < records.length - 1) const SizedBox(width: 16),
        ],
        // 填充空白以保持对齐
        if (records.length < 3) ...[
          for (int i = records.length; i < 3; i++) ...[
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()),
          ],
        ],
      ],
    );
  }

  Widget _buildGenerateInfo() {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Text(
              'Generated by RankHub',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              dateStr,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 平行四边形边框绘制器
class ParallelogramBorderPainter extends CustomPainter {
  final double skew;
  final Color color;
  final double borderWidth;

  ParallelogramBorderPainter({
    required this.skew,
    required this.color,
    this.borderWidth = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // ignore: unused_local_variable
    final path = Path()
      ..moveTo(skew, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - skew, size.height)
      ..lineTo(0, size.height)
      ..close();

    // 只绘制左右两条边
    final leftLine = Path()
      ..moveTo(skew, 0)
      ..lineTo(0, size.height);

    final rightLine = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width - skew, size.height);

    canvas.drawPath(leftLine, paint);
    canvas.drawPath(rightLine, paint);
  }

  @override
  bool shouldRepaint(ParallelogramBorderPainter oldDelegate) {
    return oldDelegate.skew != skew ||
        oldDelegate.color != color ||
        oldDelegate.borderWidth != borderWidth;
  }
}

/// 平行四边形左边框绘制器
class ParallelogramLeftBorderPainter extends CustomPainter {
  final double skew;
  final Color color;
  final double borderWidth;

  ParallelogramLeftBorderPainter({
    required this.skew,
    required this.color,
    this.borderWidth = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // 只绘制左边
    final leftLine = Path()
      ..moveTo(skew, 0)
      ..lineTo(0, size.height);

    canvas.drawPath(leftLine, paint);
  }

  @override
  bool shouldRepaint(ParallelogramLeftBorderPainter oldDelegate) {
    return oldDelegate.skew != skew ||
        oldDelegate.color != color ||
        oldDelegate.borderWidth != borderWidth;
  }
}
