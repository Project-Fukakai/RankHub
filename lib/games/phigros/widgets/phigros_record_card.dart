import 'package:flutter/material.dart';
import 'package:rank_hub/models/phigros/game_record.dart';
import 'package:rank_hub/models/phigros/song.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum PhigrosDifficulty {
  ez('EZ', Color(0xFF4CAF50)),
  hd('HD', Color(0xFF2196F3)),
  inDiff('IN', Color(0xFFF44336)),
  at('AT', Color(0xFF000000));

  final String label;
  final Color color;

  const PhigrosDifficulty(this.label, this.color);
}

class PhigrosRecordCard extends StatelessWidget {
  final PhigrosDifficulty difficulty;
  final PhigrosSong song;
  final PhigrosGameRecord record;
  final double? targetAcc;
  final double? requiredAcc;
  final String label;
  final VoidCallback? onImageLoaded;

  const PhigrosRecordCard({
    super.key,
    required this.difficulty,
    required this.song,
    required this.record,
    this.targetAcc,
    this.requiredAcc,
    required this.label,
    this.onImageLoaded,
  });

  double get constant {
    switch (difficulty) {
      case PhigrosDifficulty.ez:
        return song.difficultyEZ ?? 0;
      case PhigrosDifficulty.hd:
        return song.difficultyHD ?? 0;
      case PhigrosDifficulty.inDiff:
        return song.difficultyIN ?? 0;
      case PhigrosDifficulty.at:
        return song.difficultyAT ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Positioned(
            left: 180,
            bottom: 0,
            right: 0,
            child: _InfoCard(
              songName: song.name,
              score: record.score,
              acc: record.acc,
              targetAcc: targetAcc,
              requiredAcc: requiredAcc,
              color: difficulty.color,
            ),
          ),

          Positioned(
            left: 30,
            bottom: 0,
            child: _Image(
              imageUrl: song.illustrationLowResUrl,
              onImageLoaded: onImageLoaded,
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            child: PhysicalShape(
              clipper: ParallelogramClipper(skew: 8),
              color: difficulty.color,
              shadowColor: Colors.black,
              elevation: 4,
              child: Container(
                width: 72,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${difficulty.label} ${constant.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    Text(
                      record.rks.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 22,
            top: 20,
            child: PhysicalShape(
              clipper: ParallelogramClipper(skew: 4),
              color: Colors.white,
              shadowColor: Colors.black,
              elevation: 2,
              child: Container(
                width: 32,
                height: 20,
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String songName;
  final int score;
  final double acc;
  final double? targetAcc;
  final double? requiredAcc;
  final Color color;

  const _InfoCard({
    required this.songName,
    required this.score,
    required this.acc,
    this.targetAcc,
    this.requiredAcc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        border: Border(right: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Center(
              child: Text(
                songName,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            score.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${acc.toStringAsFixed(2)}%',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              if (requiredAcc != null) ...[
                const SizedBox(width: 6),
                Text(
                  '推分 ${requiredAcc!.toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
              if (targetAcc != null) ...[
                const SizedBox(width: 6),
                Text(
                  '>> ${targetAcc!.toStringAsFixed(2)}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onImageLoaded;

  const _Image({required this.imageUrl, this.onImageLoaded});

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      clipper: ParallelogramClipper(skew: 24),
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 180,
        height: 100,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey.shade300),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.error),
          ),
          imageBuilder: (context, imageProvider) {
            if (onImageLoaded != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onImageLoaded?.call();
              });
            }
            return Image(image: imageProvider, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}

class ParallelogramClipper extends CustomClipper<Path> {
  final double skew;

  ParallelogramClipper({this.skew = 20});

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(skew, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - skew, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
