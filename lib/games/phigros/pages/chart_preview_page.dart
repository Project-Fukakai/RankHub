import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:phasetida_flutter/phasetida_flutter.dart';
import 'package:rank_hub/models/phigros/chart.dart';
import 'package:rank_hub/models/phigros/song.dart';

class PhigrosChartPreviewPage extends StatefulWidget {
  final PhigrosSong song;
  final PhigrosChart chart;
  final String chartComposer;

  const PhigrosChartPreviewPage({
    super.key,
    required this.song,
    required this.chart,
    required this.chartComposer,
  });

  @override
  State<StatefulWidget> createState() => _PhigrosChartPreviewPageState();
}

class _PhigrosChartPreviewPageState extends State<PhigrosChartPreviewPage> {
  late String json;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    json = widget.chart.toJsonString();
    FullScreen.setFullScreen(true);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
    FullScreen.setFullScreen(false);
  }

  @override
  Widget build(BuildContext context) {
    return PhigrosChartPlayerShellWidget(
      jsonData: json,
      songName: widget.song.name,
      author: widget.song.composer,
      chartComposer: widget.chartComposer,
      quitCallback: () {
        Navigator.pop(context);
      },
    );
  }
}
