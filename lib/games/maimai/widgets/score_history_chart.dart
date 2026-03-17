import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// 历史成绩图表组件
class ScoreHistoryChart extends StatelessWidget {
  final List<Map<String, dynamic>> historyData;

  const ScoreHistoryChart({super.key, required this.historyData});

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (historyData.isEmpty) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(32), child: Text('暂无历史成绩数据')),
      );
    }

    // 过滤掇80%以上的数据
    final filteredData = historyData.where((data) {
      final achievements = (data['achievements'] as num).toDouble();
      return achievements >= 80.0;
    }).toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('暂无 80% 以上的成绩数据'),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final spots = _prepareSpots(filteredData);

    // 根据过滤后数据的最低点决定最小值
    final achievements = filteredData
        .map((e) => (e['achievements'] as num).toDouble())
        .toList();
    final dataMinY = achievements.reduce((a, b) => a < b ? a : b);
    final minY = (dataMinY - 1).floorToDouble().clamp(
      80.0,
      100.0,
    ); // 最低点减1并向下取整，但不低于80%
    final maxY = 101.0; // 固定最大值为101%
    final yInterval = _calculateYInterval(minY, maxY);

    return LineChart(
      transformationConfig: FlTransformationConfig(
        scaleAxis: FlScaleAxis.horizontal,
        minScale: 1.0,
        maxScale: 25.0,
        panEnabled: true,
        scaleEnabled: true,
      ),
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= filteredData.length) {
                  return const SizedBox();
                }
                final playTime = DateTime.parse(
                  filteredData[index]['play_time'],
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      _formatDate(playTime),
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: yInterval,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: colorScheme.outlineVariant),
            bottom: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        minX: 0,
        maxX: (filteredData.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                colorScheme.surfaceContainerHighest,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final data = filteredData[index];
                final playTime = DateTime.parse(data['play_time']);
                final achievements = (data['achievements'] as num).toDouble();
                final dxScore = data['dx_score'] as int;
                final rate = data['rate'] as String?;
                final fc = data['fc'] as String?;
                final fs = data['fs'] as String?;

                final badges = <String>[];
                if (rate != null) badges.add(rate.toUpperCase());
                if (fc != null) badges.add(fc.toUpperCase());
                if (fs != null) badges.add(fs.toUpperCase());

                return LineTooltipItem(
                  '${_formatDateTime(playTime)}\n'
                  '达成率: ${achievements.toStringAsFixed(4)}%\n'
                  'DX分数: $dxScore\n'
                  '${badges.isNotEmpty ? badges.join(' | ') : ''}',
                  TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  /// 计算合适的Y轴间隔
  double _calculateYInterval(double minY, double maxY) {
    final range = maxY - minY;

    // 根据范围动态调整间隔
    if (range <= 2) {
      return 0.5; // 范围小于等于2%，每0.5%一个刻度
    } else if (range <= 5) {
      return 1.0; // 范围小于等于5%，每1%一个刻度
    } else if (range <= 10) {
      return 2.0; // 范围小于等于10%，每2%一个刻度
    } else {
      return 5.0; // 范围大于10%，每5%一个刻度
    }
  }

  List<FlSpot> _prepareSpots(List<Map<String, dynamic>> data) {
    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      final achievements = (data[i]['achievements'] as num).toDouble();
      spots.add(FlSpot(i.toDouble(), achievements));
    }
    return spots;
  }
}
