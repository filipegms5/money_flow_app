import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/models/categoria_gasto_model.dart';

class CategorySpendingCard extends StatefulWidget {
  const CategorySpendingCard({super.key});

  @override
  State<CategorySpendingCard> createState() => _CategorySpendingCardState();
}

class _CategorySpendingCardState extends State<CategorySpendingCard> {
  final TransacoesController _controller = TransacoesController();
  bool _loading = true;
  String? _error;
  List<CategoriaGasto> _data = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _controller.fetchGastosCategoriasUltimoMes();
      setState(() {
        _data = res;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Gastos por Categoria (30 dias)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(height: 140, child: _buildChartArea()),
            const SizedBox(height: 8),
            _buildLegendArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartArea() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Erro ao carregar dados'),
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: _load, child: const Text('Tentar novamente')),
        ],
      );
    }
    if (_data.isEmpty) {
      return const Center(child: Text('Sem gastos neste período'));
    }

    final totalSum = _data.fold<double>(0, (sum, e) => sum + e.total);
    final colors = _fixedColors();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: PieChart(
        PieChartData(
          sectionsSpace: 1,
          centerSpaceRadius: 28,
          borderData: FlBorderData(show: false),
          sections: List.generate(_data.length, (i) {
            final item = _data[i];
            final percent = totalSum == 0 ? 0 : (item.total / totalSum) * 100;
            return PieChartSectionData(
              value: item.total,
              color: colors[i % colors.length],
              title: '${percent.toStringAsFixed(1)}%',
              titleStyle: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
              radius: 40,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLegendArea() {
    if (_loading || _error != null || _data.isEmpty) {
      return const SizedBox.shrink();
    }
    final totalSum = _data.fold<double>(0, (sum, e) => sum + e.total);
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final colors = _fixedColors();
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: List.generate(_data.length, (i) {
        final item = _data[i];
        final percent = totalSum == 0 ? 0 : (item.total / totalSum) * 100;
        return _LegendItem(
          color: colors[i % colors.length],
          label: item.nome,
          value: '${currency.format(item.total)} · ${percent.toStringAsFixed(1)}%',
        );
      }),
    );
  }

  List<Color> _fixedColors() => const [
        Color(0xFF2196F3), // blue
        Color(0xFF3F51B5), // indigo
        Color(0xFF673AB7), // deepPurple
        Color(0xFF9C27B0), // purple
        Color(0xFF00BCD4), // cyan
        Color(0xFF03A9F4), // lightBlue
        Color(0xFF9E9E9E), // grey
        Color(0xFF795548), // brown
        Color(0xFF607D8B), // blueGrey
        Color(0xFFFFC107), // amber (não é vermelho/verde)
        Color(0xFFFF9800), // orange (não é vermelho/verde)
      ];
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}


