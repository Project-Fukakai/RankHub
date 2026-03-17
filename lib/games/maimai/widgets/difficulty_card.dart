import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/models/maimai_score.dart';
import 'package:rank_hub/games/maimai/models/enums/level_index.dart';
import 'package:rank_hub/games/maimai/models/enums/song_type.dart';
import 'package:rank_hub/games/maimai/models/enums/fc_type.dart';
import 'package:rank_hub/games/maimai/models/enums/fs_type.dart';
import 'package:rank_hub/games/maimai/viewmodels/maimai_song_view_model.dart';
import 'package:rank_hub/core/detail_navigation.dart';
import '../pages/difficulty_detail_page.dart';
import '../services/maimai_isar_service.dart';

/// 谱面难度卡片组件
class DifficultyCard extends ConsumerStatefulWidget {
  final dynamic difficulty; // SongDifficulty or SongDifficultyUtage
  final int songId;
  final String songName;
  final bool isUtage;

  const DifficultyCard({
    super.key,
    required this.difficulty,
    required this.songId,
    required this.songName,
    this.isUtage = false,
  });

  @override
  ConsumerState<DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends ConsumerState<DifficultyCard> {
  MaimaiScore? playerScore;

  @override
  void initState() {
    super.initState();
    _loadPlayerScore();
  }

  Future<void> _loadPlayerScore() async {
    try {
      final score = await MaimaiIsarService.instance
          .getScoreBySongIdAndDifficulty(
            songId: widget.songId,
            levelIndex: widget.difficulty.difficulty,
            type: widget.difficulty.type,
          );
      if (mounted) {
        setState(() {
          playerScore = score;
        });
      }
    } catch (e) {
      // 忽略错误，可能没有成绩
    }
  }

  List<String> _splitLevelValue() {
    return widget.difficulty.levelValue.toStringAsFixed(1).split('.');
  }

  Color _getCardBgColor() {
    switch (widget.difficulty.difficulty) {
      case LevelIndex.basic:
        return Colors.green.shade600;
      case LevelIndex.advanced:
        return Colors.yellow.shade800;
      case LevelIndex.expert:
        return Colors.red.shade600;
      case LevelIndex.master:
        return Colors.purple.shade600;
      case LevelIndex.reMaster:
        return Colors.purple.shade300;
      default:
        return Colors.blue.shade600;
    }
  }

  Color _getCardBorderColor() {
    switch (widget.difficulty.difficulty) {
      case LevelIndex.basic:
        return Colors.green.shade900;
      case LevelIndex.advanced:
        return Colors.yellow.shade900;
      case LevelIndex.expert:
        return Colors.red.shade900;
      case LevelIndex.master:
        return Colors.purple.shade900;
      case LevelIndex.reMaster:
        return Colors.purple.shade600;
      default:
        return Colors.blue.shade900;
    }
  }

  MaterialColor _getTypeColor(SongType type) {
    if (type == SongType.standard) {
      return Colors.blue;
    } else if (type == SongType.dx) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  List<String> _splitAchievements() {
    if (playerScore == null) {
      return ['0', '0000'];
    }
    return playerScore!.achievements.toStringAsFixed(4).split('.');
  }

  MaterialColor _getFcColor(FCType fc) {
    switch (fc) {
      case FCType.fc:
      case FCType.fcPlus:
        return Colors.green;
      case FCType.ap:
      case FCType.apPlus:
        return Colors.orange;
    }
  }

  String _getFcText(FCType fc) {
    switch (fc) {
      case FCType.fc:
        return 'FC';
      case FCType.fcPlus:
        return 'FC+';
      case FCType.ap:
        return 'AP';
      case FCType.apPlus:
        return 'AP+';
    }
  }

  MaterialColor _getFsColor(FSType fs) {
    switch (fs) {
      case FSType.sync:
        return Colors.lightBlue;
      case FSType.fs:
      case FSType.fsPlus:
        return Colors.blue;
      case FSType.fsd:
      case FSType.fsdPlus:
        return Colors.orange;
    }
  }

  String _getFsText(FSType fs) {
    switch (fs) {
      case FSType.sync:
        return 'SYNC';
      case FSType.fs:
        return 'FS';
      case FSType.fsPlus:
        return 'FS+';
      case FSType.fsd:
        return 'FSD';
      case FSType.fsdPlus:
        return 'FSD+';
    }
  }

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _getCardBgColor();
    final borderColor = _getCardBorderColor();
    final typeLabel = widget.difficulty.type == SongType.dx ? 'DX' : '标准';
    final typeColor = _getTypeColor(widget.difficulty.type);
    ref.watch(maimaiSongViewModelProvider);
    final versionTitle = ref
        .read(maimaiSongViewModelProvider.notifier)
        .getVersionLabel(widget.difficulty.version);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 4),
        ),
        color: difficultyColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            pushDetailPage(
              context,
              DifficultyDetailPage(
                difficulty: widget.difficulty,
                songName: widget.songName,
                songId: widget.songId,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 第一行：难度标签、定数、类型
                Row(
                  children: [
                    Text(
                      widget.difficulty.difficulty.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _splitLevelValue()[0],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '.${_splitLevelValue()[1]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.difficulty.levelValue % 1 > 0.5)
                      Transform.translate(
                        offset: const Offset(4, -8),
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Chip(
                      side: BorderSide(width: 2, color: typeColor.shade700),
                      label: Text(
                        typeLabel,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: typeColor,
                    ),
                  ],
                ),
                const Opacity(opacity: 0.6, child: Divider()),
                // 玩家成绩信息
                if (playerScore != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // 达成率
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '达成率',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _splitAchievements()[0],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '.${_splitAchievements()[1]}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // FC 标记
                      if (playerScore!.fc != null) ...[
                        Chip(
                          side: BorderSide(
                            width: 2,
                            color: _getFcColor(playerScore!.fc!).shade700,
                          ),
                          label: Text(
                            _getFcText(playerScore!.fc!),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getFcColor(playerScore!.fc!),
                        ),
                        const SizedBox(width: 8),
                      ],
                      // FS 标记
                      if (playerScore!.fs != null)
                        Chip(
                          side: BorderSide(
                            width: 2,
                            color: _getFsColor(playerScore!.fs!).shade700,
                          ),
                          label: Text(
                            _getFsText(playerScore!.fs!),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getFsColor(playerScore!.fs!),
                        ),
                    ],
                  ),
                  const Opacity(opacity: 0.6, child: Divider()),
                ],
                const SizedBox(height: 8),
                // 谱师和版本信息
                Row(
                  children: [
                    const Text('谱师: '),
                    Expanded(
                      child: Text(
                        widget.difficulty.noteDesigner.isEmpty
                            ? '未知'
                            : widget.difficulty.noteDesigner,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('版本: '),
                    Text(
                      versionTitle.isEmpty
                          ? '加载中...'
                          : versionTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // 宴会场特殊信息
                if (widget.isUtage &&
                    widget.difficulty is MaimaiSongDifficultyUtage) ...[
                  const SizedBox(height: 8),
                  if ((widget.difficulty as MaimaiSongDifficultyUtage)
                      .kanji
                      .isNotEmpty)
                    Chip(
                      label: Text(
                        (widget.difficulty as MaimaiSongDifficultyUtage).kanji,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.purple,
                      side: BorderSide(color: Colors.purple.shade700, width: 2),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
