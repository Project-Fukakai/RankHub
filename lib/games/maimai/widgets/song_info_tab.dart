import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/viewmodels/maimai_song_view_model.dart';
import '../services/maimai_isar_service.dart';

/// 曲目信息标签页
class SongInfoTab extends ConsumerStatefulWidget {
  final MaimaiSong song;

  const SongInfoTab({super.key, required this.song});

  @override
  ConsumerState<SongInfoTab> createState() => _SongInfoTabState();
}

class _SongInfoTabState extends ConsumerState<SongInfoTab> {
  List<String>? _aliases;

  @override
  void initState() {
    super.initState();
    _loadAliases();
  }

  Future<void> _loadAliases() async {
    final aliasData = await MaimaiIsarService.instance.getAliasBySongId(
      widget.song.songId,
    );
    if (mounted) {
      setState(() {
        _aliases = aliasData?.aliases;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(maimaiSongViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // 基本信息卡片
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '基本信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  context,
                  icon: Icons.music_note,
                  label: '曲名',
                  value: widget.song.title,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  context,
                  icon: Icons.person,
                  label: '艺术家',
                  value: widget.song.artist,
                  colorScheme: colorScheme,
                ),
                if (_aliases != null && _aliases!.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildAliasRow(
                    context,
                    aliases: _aliases!,
                    colorScheme: colorScheme,
                  ),
                ],
                const Divider(height: 24),
                _buildInfoRow(
                  context,
                  icon: Icons.category,
                  label: '分类',
                  value: widget.song.genre,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _buildSongIdRow(context, colorScheme: colorScheme),
                const Divider(height: 24),
                _buildInfoRow(
                  context,
                  icon: Icons.speed,
                  label: 'BPM',
                  value: widget.song.bpm.toString(),
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  context,
                  icon: Icons.update,
                  label: '版本',
                  value: (() {
                    final label = ref
                        .read(maimaiSongViewModelProvider.notifier)
                        .getVersionLabel(widget.song.version);
                    return label.isEmpty ? '加载中...' : label;
                  })(),
                  colorScheme: colorScheme,
                ),
                if (widget.song.map != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    context,
                    icon: Icons.map,
                    label: '区域',
                    value: widget.song.map!,
                    colorScheme: colorScheme,
                  ),
                ],
                if (widget.song.locked) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    context,
                    icon: Icons.lock,
                    label: '状态',
                    value: '需要解锁',
                    colorScheme: colorScheme,
                    valueColor: Colors.orange,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 版权信息卡片
        if (widget.song.rights != null && widget.song.rights!.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.copyright,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '版权信息',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.song.rights!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        // 谱面统计卡片
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '谱面统计',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDifficultyStats(colorScheme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
    Color? valueColor,
  }) {
    return InkWell(
      onTap: () => _copyToClipboard(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.copy,
              size: 16,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  /// 复制到剪贴板
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已复制: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 构建曲目ID信息行
  Widget _buildSongIdRow(
    BuildContext context, {
    required ColorScheme colorScheme,
  }) {
    final hasDx = widget.song.difficulties.dx.isNotEmpty;
    final standardId = widget.song.songId.toString();
    final dxId = (widget.song.songId + 10000).toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tag, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '曲目ID',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildIdChip(standardId, hasDx ? '标准' : null, colorScheme),
                if (hasDx) _buildIdChip(dxId, 'DX', colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建ID chip
  Widget _buildIdChip(String id, String? label, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _copyToClipboard(id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              id,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建别名信息行
  Widget _buildAliasRow(
    BuildContext context, {
    required List<String> aliases,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.subtitles, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '别名',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: aliases
                  .map(
                    (alias) => InkWell(
                      onTap: () => _copyToClipboard(alias),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alias,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建谱面统计信息
  Widget _buildDifficultyStats(ColorScheme colorScheme) {
    final standardCount = widget.song.difficulties.standard.length;
    final dxCount = widget.song.difficulties.dx.length;
    final utageCount = widget.song.difficulties.utage.length;
    final totalCount = standardCount + dxCount + utageCount;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              '总计',
              totalCount.toString(),
              Colors.blue,
              colorScheme,
            ),
            _buildStatItem(
              '标准',
              standardCount.toString(),
              Colors.green,
              colorScheme,
            ),
            _buildStatItem(
              'DX',
              dxCount.toString(),
              Colors.orange,
              colorScheme,
            ),
            if (utageCount > 0)
              _buildStatItem(
                '宴会场',
                utageCount.toString(),
                Colors.purple,
                colorScheme,
              ),
          ],
        ),
        const SizedBox(height: 16),
        // 难度范围
        if (standardCount > 0 || dxCount > 0) ...[
          const Divider(),
          const SizedBox(height: 12),
          _buildLevelRange(colorScheme),
        ],
      ],
    );
  }

  /// 构建统计项
  Widget _buildStatItem(
    String label,
    String value,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  /// 构建定数范围信息
  Widget _buildLevelRange(ColorScheme colorScheme) {
    final allDifficulties = [
      ...widget.song.difficulties.standard,
      ...widget.song.difficulties.dx,
    ];

    if (allDifficulties.isEmpty) return const SizedBox.shrink();

    final minLevel = allDifficulties
        .map((d) => d.levelValue)
        .reduce((a, b) => a < b ? a : b);
    final maxLevel = allDifficulties
        .map((d) => d.levelValue)
        .reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.show_chart, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '定数范围: ',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        Text(
          '${minLevel.toStringAsFixed(1)} - ${maxLevel.toStringAsFixed(1)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
