import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/widgets/overview/month_data.dart';
import 'package:money_flow_app/widgets/overview/three_month_chart.dart';
import 'package:money_flow_app/widgets/overview/legend.dart';

class OverviewReceitaDespesaCard extends StatefulWidget {
  const OverviewReceitaDespesaCard({super.key});

  @override
  State<OverviewReceitaDespesaCard> createState() => _OverviewReceitaDespesaCardState();
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
      final months = <Map<String, Object>>[];
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
            if (t.tipo.toLowerCase() == 'receita') {
              receitas += valor;
            } else {
              despesas += valor;
            }
          }

          data.add(MonthData(label: month['label'] as String, receitas: receitas, despesas: despesas));
        } catch (_) {
          data.add(MonthData(label: month['label'] as String, receitas: 0, despesas: 0));
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
                      const Text('Últimos 3 meses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      ThreeMonthChart(monthsData: _monthsData),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Legend(color: Colors.green, label: 'Receitas'),
                          SizedBox(width: 24),
                          Legend(color: Colors.red, label: 'Despesas'),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}



