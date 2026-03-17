import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rank_hub/games/maimai/models/maimai_song.dart';
import 'package:rank_hub/games/maimai/widgets/difficulty_card.dart';
import 'package:rank_hub/games/maimai/widgets/song_info_tab.dart';
import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:marquee/marquee.dart';

/// 乐曲详情页面
class SongDetailPage extends StatefulWidget {
  final MaimaiSong song;

  const SongDetailPage({super.key, required this.song});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  double _titleOpacity = 0.0;
  bool _showFloatingButton = false; // 是否显示浮动按钮

  // 音频播放相关
  late AudioPlayer _audioPlayer;
  late AnimationController _iconController;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isLoaded = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (!context.mounted) return;
      setState(() {
        _titleOpacity = ((_scrollController.offset - 178) / 72).clamp(0.0, 1.0);
        // 当AppBar折叠后显示浮动按钮 (滚动距离超过250时,AppBar基本完全折叠)
        _showFloatingButton = _scrollController.offset > 250;
      });
    });

    // 初始化音频播放器
    _audioPlayer = AudioPlayer();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // 监听音频播放状态
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (_isPlaying) {
          _iconController.forward();
        } else {
          _iconController.reverse();
        }
      });
    });

    // 监听音频加载进度
    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (!mounted) return;
      _audioPlayer.getDuration().then((duration) {
        if (duration != null && duration.inMilliseconds > 0) {
          setState(() {
            _progress = position.inMilliseconds / duration.inMilliseconds;
            _isLoaded = true;
            _isLoading = false;
          });
        }
      });
    });

    // 监听播放完成
    _audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _progress = 0.0;
        _iconController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isEmbeddedMode = width >= 1024;

    return Scaffold(
      extendBodyBehindAppBar: !isEmbeddedMode,
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _showFloatingButton ? 1.0 : 0.0,
        curve: Curves.easeInOut,
        child: _buildFloatingPlayButton(),
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // AppBar with cover image
            SliverAppBar(
              primary: true,
              titleSpacing: 0,
              stretch: true,
              forceElevated: true,
              centerTitle: false,
              automaticallyImplyLeading: !isEmbeddedMode,
              backgroundColor: colorScheme.surface.withOpacity(0.95),
              surfaceTintColor: Colors.transparent,
              title: Opacity(
                opacity: _titleOpacity,
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  isThreeLine: false,
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://assets2.lxns.net/maimai/jacket/${widget.song.songId}.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 500),
                      placeholder: (context, url) => Transform.scale(
                        scale: 0.4,
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(
                    widget.song.title,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    widget.song.artist,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _shareSong,
                  icon: const Icon(Icons.share),
                ),
                const SizedBox(width: 8),
              ],
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  FlexibleSpaceBar(
                    stretchModes: const [StretchMode.blurBackground],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 背景图片
                        GestureDetector(
                          onTap: _showCoverImage,
                          child: Opacity(
                            opacity: 0.5,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://assets2.lxns.net/maimai/jacket/${widget.song.songId}.png',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        // 前景内容
                        _buildExtendedContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '曲目信息'),
                    Tab(text: '谱面信息'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // 曲目信息
            SongInfoTab(song: widget.song),
            // 谱面信息
            _buildDifficultiesTab(),
          ],
        ),
      ),
    );
  }

  /// 构建扩展内容（标题、艺术家等）
  Widget _buildExtendedContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 标题字体样式
        const titleStyle = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
        const artistStyle = TextStyle(fontSize: 16);
        // 允许的最大宽度(减去按钮和padding)
        final maxTitleWidth = constraints.maxWidth - 100 - 8 - 16;
        final maxArtistWidth = constraints.maxWidth - 16;

        // 计算文本宽度
        double textWidth(String text, TextStyle style) {
          final tp = TextPainter(
            text: TextSpan(text: text, style: style),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();
          return tp.width;
        }

        final needTitleMarquee =
            textWidth(widget.song.title, titleStyle) > maxTitleWidth;
        final needArtistMarquee =
            textWidth(widget.song.artist, artistStyle) > maxArtistWidth;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 标题和播放按钮
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: needTitleMarquee
                          ? ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: const [
                                    Colors.transparent,
                                    Colors.white,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.05, 0.95, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Marquee(
                                text: widget.song.title,
                                style: titleStyle,
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 80.0,
                                velocity: 40.0,
                                pauseAfterRound: const Duration(seconds: 2),
                                startPadding: 10.0,
                                accelerationDuration: const Duration(
                                  seconds: 1,
                                ),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                decelerationCurve: Curves.easeOut,
                              ),
                            )
                          : Text(
                              widget.song.title,
                              style: titleStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 音频播放按钮
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // 圆形按钮
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.zero),
                            shape: WidgetStatePropertyAll(CircleBorder()),
                          ),
                          onPressed: _playPauseAudio,
                          child: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: _iconController,
                            size: 32,
                          ),
                        ),
                      ),
                      // 圆形进度指示器
                      if (_isLoaded || _isLoading)
                        IgnorePointer(
                          ignoring: !_isLoading,
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: _isLoading ? null : _progress,
                              strokeWidth: 4.0,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              // 艺术家
              SizedBox(
                height: 24,
                child: needArtistMarquee
                    ? ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.05, 0.95, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Marquee(
                          text: widget.song.artist,
                          style: artistStyle,
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 60.0,
                          velocity: 30.0,
                          pauseAfterRound: const Duration(seconds: 2),
                          startPadding: 10.0,
                          accelerationDuration: const Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: const Duration(
                            milliseconds: 500,
                          ),
                          decelerationCurve: Curves.easeOut,
                        ),
                      )
                    : Text(
                        widget.song.artist,
                        style: artistStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建谱面信息标签页
  Widget _buildDifficultiesTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "点击卡片即可查看详细信息",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 标准谱面
          if (widget.song.difficulties.standard.isNotEmpty) ...[
            for (
              int i = widget.song.difficulties.standard.length - 1;
              i >= 0;
              i--
            )
              DifficultyCard(
                difficulty: widget.song.difficulties.standard[i],
                songId: widget.song.songId,
                songName: widget.song.title,
              ),
          ],
          // DX 谱面
          if (widget.song.difficulties.dx.isNotEmpty) ...[
            for (int i = widget.song.difficulties.dx.length - 1; i >= 0; i--)
              DifficultyCard(
                difficulty: widget.song.difficulties.dx[i],
                songId: widget.song.songId,
                songName: widget.song.title,
              ),
          ],
          // 宴会场谱面
          if (widget.song.difficulties.utage.isNotEmpty) ...[
            for (int i = widget.song.difficulties.utage.length - 1; i >= 0; i--)
              DifficultyCard(
                difficulty: widget.song.difficulties.utage[i],
                songId: widget.song.songId,
                songName: widget.song.title,
                isUtage: true,
              ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 分享乐曲
  void _shareSong() {
    final shareUrl =
        'https://maimai.lxns.net/songs?game=maimai&song_id=${widget.song.songId}';
    final shareText = '${widget.song.title} - ${widget.song.artist}\n$shareUrl';

    Share.share(
      shareText,
      subject: widget.song.title,
      sharePositionOrigin: Rect.fromLTWH(0, 0, 1, 1),
    );
  }

  /// 构建浮动播放按钮
  Widget _buildFloatingPlayButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 圆形按钮
        SizedBox(
          width: 64,
          height: 64,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              shape: WidgetStatePropertyAll(CircleBorder()),
            ),
            onPressed: _playPauseAudio,
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _iconController,
              size: 32,
            ),
          ),
        ),
        // 圆形进度指示器
        if (_isLoaded || _isLoading)
          IgnorePointer(
            child: SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                value: _isLoading ? null : _progress,
                strokeWidth: 4.0,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
      ],
    );
  }

  /// 播放/暂停音频
  Future<void> _playPauseAudio() async {
    try {
      if (_isPlaying) {
        // 暂停播放
        await _audioPlayer.pause();
      } else {
        // 开始或继续播放
        if (_progress > 0 && _progress < 1) {
          // 继续播放
          await _audioPlayer.resume();
        } else {
          // 开始播放
          setState(() {
            _isLoading = true;
            _progress = 0.0;
          });

          final audioUrl =
              'https://assets2.lxns.net/maimai/music/${widget.song.songId}.mp3';
          await _audioPlayer.play(UrlSource(audioUrl));
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('播放失败: $e')));
    }
  }

  /// 显示封面大图
  void _showCoverImage() {
    final imageUrl =
        'https://assets2.lxns.net/maimai/jacket/${widget.song.songId}.png';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: () => _saveImage(imageUrl, widget.song.title),
                tooltip: '保存到相册',
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () => _shareImage(imageUrl),
                tooltip: '分享',
              ),
            ],
          ),
          body: PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? null
                    : event.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 1),
                color: Colors.white,
              ),
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 保存图片到相册
  Future<void> _saveImage(String imageUrl, String? songTitle) async {
    try {
      // 检查权限
      PermissionStatus status;
      if (Platform.isIOS) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
        if (status.isDenied) {
          status = await Permission.photos.request();
        }
      }

      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('需要存储权限才能保存图片')));
        return;
      }

      // 显示加载提示
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('正在保存...')));

      // 下载图片
      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // 获取保存路径
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }

      if (directory == null) {
        throw Exception('无法获取存储目录');
      }

      // 生成文件名
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = songTitle != null
          ? '${songTitle.replaceAll(RegExp(r'[^\w\s-]'), '_')}_$timestamp.png'
          : 'maimai_jacket_${widget.song.songId}_$timestamp.png';
      final filePath = '${directory.path}/$fileName';

      // 保存文件
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('图片已保存: $fileName'),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
    }
  }

  /// 分享图片
  Future<void> _shareImage(String imageUrl) async {
    try {
      // 显示加载提示
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('正在准备分享...')));

      // 下载图片到临时目录
      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final tempDir = await getTemporaryDirectory();
      final fileName = 'maimai_jacket_${widget.song.songId}.png';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // 分享文件
      await Share.shareXFiles(
        [XFile(filePath)],
        text: '${widget.song.title} - ${widget.song.artist}',
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('分享失败: $e')));
    }
  }
}

/// Tab Bar 的 SliverPersistentHeaderDelegate
class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
          child: _tabBar,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) {
    return false;
  }
}
