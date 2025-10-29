import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_flow_app/widgets/overview/month_data.dart';

class ThreeMonthChart extends StatelessWidget {
  final List<MonthData> monthsData;

  const ThreeMonthChart({super.key, required this.monthsData});

  String _formatValue(double value, double maxValue) {
    if (value == 0) return '';
    if (maxValue >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (monthsData.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('Sem dados')));
    }

    final maxValue = monthsData
        .map((m) => [m.receitas, m.despesas])
        .expand((e) => e)
        .fold<double>(0, (prev, e) => e > prev ? e : prev);

    final safeMax = maxValue == 0 ? 1.0 : maxValue;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String title;
                if (rodIndex == 0) {
                  title = 'Receitas';
                } else {
                  title = 'Despesas';
                }
                return BarTooltipItem(
                  '$title\n${_formatValue(rod.toY, safeMax)}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < monthsData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        monthsData[value.toInt()].label,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            horizontalInterval: safeMax / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          barGroups: List.generate(monthsData.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthsData[index].receitas,
                  color: Colors.green,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                BarChartRodData(
                  toY: monthsData[index].despesas,
                  color: Colors.red,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
              barsSpace: 4,
            );
          }),
          maxY: safeMax * 1.2,
          alignment: BarChartAlignment.spaceAround,
        ),
      ),
    );
  }
}