import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';

class DriftChart extends StatelessWidget {
  final List<double> driftHistory;
  const DriftChart({super.key, required this.driftHistory});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: driftHistory.isNotEmpty ? driftHistory.length.toDouble() : 0,
        minY: 0,
        maxY: driftHistory.isNotEmpty
            ? driftHistory.reduce((a, b) => a > b ? a : b) + 5
            : 10,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                driftHistory.length,
                (i) => FlSpot(i.toDouble(), driftHistory[i])
            ),
            isCurved: true,
            dotData: FlDotData(show: false),
          )
        ]
      )
    );
  }
}
