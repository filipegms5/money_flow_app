import 'package:flutter/material.dart';
import 'package:money_flow_app/widgets/overview/month_bar.dart';
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
      return const SizedBox(height: 120, child: Center(child: Text('Sem dados')));
    }

    final maxValue = monthsData
        .map((m) => [m.receitas, m.despesas])
        .expand((e) => e)
        .fold<double>(0, (prev, e) => e > prev ? e : prev);

    final safeMax = maxValue == 0 ? 1.0 : maxValue;

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: monthsData.map((month) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 115,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MonthBar(
                            value: month.receitas / safeMax,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: MonthBar(
                            value: month.despesas / safeMax,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatValue(month.receitas, safeMax),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          _formatValue(month.despesas, safeMax),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    month.label,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


