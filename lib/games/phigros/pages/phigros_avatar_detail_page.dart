import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rank_hub/models/phigros/avatar.dart';

class PhigrosAvatarDetailArgs {
  final PhigrosAvatar avatar;

  const PhigrosAvatarDetailArgs({required this.avatar});
}

class PhigrosAvatarDetailPage extends StatefulWidget {
  final PhigrosAvatarDetailArgs args;

  const PhigrosAvatarDetailPage({super.key, required this.args});

  @override
  State<PhigrosAvatarDetailPage> createState() =>
      _PhigrosAvatarDetailPageState();
}

class _PhigrosAvatarDetailPageState extends State<PhigrosAvatarDetailPage> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final avatar = widget.args.avatar;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(avatar.avatarName),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download, color: Colors.white),
            onPressed: _isSaving ? null : () => _saveImage(avatar),
            tooltip: '保存到相册',
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(avatar.avatarUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? null
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            color: Colors.white,
          ),
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.image_not_supported, color: Colors.white, size: 64),
        ),
      ),
    );
  }

  Future<void> _saveImage(PhigrosAvatar avatar) async {
    setState(() {
      _isSaving = true;
    });
    try {
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

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('正在保存...')));

      final dio = Dio();
      final response = await dio.get(
        avatar.avatarUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }

      if (directory == null) {
        throw Exception('无法获取存储目录');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeName = avatar.avatarName.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final fileName = 'phigros_avatar_${safeName}_$timestamp.png';
      final filePath = '${directory.path}/$fileName';

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
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }
}
