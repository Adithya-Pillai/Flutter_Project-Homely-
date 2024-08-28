import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/loading.dart';

class RevenueChart extends StatelessWidget {
  final Future<List<FlSpot>> revenueDataFuture;

  RevenueChart({required this.revenueDataFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: revenueDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final spots = snapshot.data!;

        return Container(
          height: 300, // Adjust height as needed
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 6),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide bottom titles
                  ),
                  axisNameWidget: Text('Day in the month'),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide left titles
                  ),
                  axisNameWidget: Text('Total Earning / Day'),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black12, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.blueAccent[400],
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      return LineTooltipItem(
                        '${touchedSpot.x.toInt()}: \Rs.${touchedSpot.y}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  // Handle the touch response here
                },
                handleBuiltInTouches: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
