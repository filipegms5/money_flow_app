import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/models/transacao_model.dart';

class OverviewReceitaDespesaCard extends StatefulWidget {
  const OverviewReceitaDespesaCard({super.key});

  @override
  State<OverviewReceitaDespesaCard> createState() => _OverviewReceitaDespesaCardState();
}

class MonthData {
  final String label;
  final double receitas;
  final double despesas;

  MonthData({
    required this.label,
    required this.receitas,
    required this.despesas,
  });
}

class _OverviewReceitaDespesaCardState extends State<OverviewReceitaDespesaCard> {
  final TransacoesController _controller = TransacoesController();
  bool _loading = true;
  String? _error;
  List<MonthData> _monthsData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final now = DateTime.now();
      final months = [];
      
      // Get last 3 months
      for (int i = 0; i < 3; i++) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        final startOfMonth = DateTime(monthDate.year, monthDate.month, 1);
        final endOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0, 23, 59, 59);
        
        months.add({
          'label': _getMonthAbbreviation(monthDate),
          'start': startOfMonth,
          'end': endOfMonth,
        });
      }

      // Fetch data for each month
      final List<MonthData> data = [];
      for (var month in months.reversed) {
        try {
          final transacoes = await _controller.fetchTransacoesPeriodo(
            start: month['start'] as DateTime,
            end: month['end'] as DateTime,
          );

          double receitas = 0;
          double despesas = 0;
          for (final t in transacoes) {
            final valor = t.valor;
            if ((t.tipo).toLowerCase() == 'receita') {
              receitas += valor;
            } else {
              despesas += valor;
            }
          }

          data.add(MonthData(
            label: month['label'] as String,
            receitas: receitas,
            despesas: despesas,
          ));
        } catch (e) {
          // If one month fails, add with zeros
          data.add(MonthData(
            label: month['label'] as String,
            receitas: 0,
            despesas: 0,
          ));
        }
      }

      setState(() {
        _monthsData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _getMonthAbbreviation(DateTime date) {
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Erro ao carregar dados'),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      OutlinedButton(onPressed: _loadData, child: const Text('Tentar novamente')),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Últimos 3 meses',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _ThreeMonthChart(monthsData: _monthsData),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Legend(color: Colors.green, label: 'Receitas'),
                          const SizedBox(width: 24),
                          _Legend(color: Colors.red, label: 'Despesas'),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _ThreeMonthChart extends StatelessWidget {
  final List<MonthData> monthsData;

  const _ThreeMonthChart({required this.monthsData});

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

    final maxValue = monthsData.isEmpty
        ? 1.0
        : monthsData
            .map((m) => [m.receitas, m.despesas])
            .expand((e) => e)
            .reduce((a, b) => a > b ? a : b);

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
                          child: _MonthBar(
                            value: month.receitas / safeMax,
                            color: Colors.green,
                            label: '',
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: _MonthBar(
                            value: month.despesas / safeMax,
                            color: Colors.red,
                            label: '',
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

class _MonthBar extends StatelessWidget {
  final double value;
  final Color color;
  final String label;

  const _MonthBar({required this.value, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight * value;
          return Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
