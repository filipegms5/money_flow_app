import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/controllers/meta_financeira_controller.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/models/meta_financeira_model.dart';
import 'package:money_flow_app/pages/criar_meta_page.dart';
import 'package:money_flow_app/pages/detalhes_meta_page.dart';
import 'package:money_flow_app/widgets/goal/meta_status_badge.dart';

class MetaFinanceiraCard extends StatefulWidget {
  const MetaFinanceiraCard({super.key});

  @override
  State<MetaFinanceiraCard> createState() => _MetaFinanceiraCardState();
}

class _MetaFinanceiraCardState extends State<MetaFinanceiraCard> {
  final MetaFinanceiraController _metaController = MetaFinanceiraController();
  final TransacoesController _transacoesController = TransacoesController();
  
  bool _loading = true;
  String? _error;
  MetaFinanceira? _metaAtiva;
  double _progressoAtual = 0;

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
      final meta = await _metaController.fetchMetaAtiva();
      
      if (meta != null) {
        // Calcula o progresso baseado nas transações
        final transacoes = await _transacoesController.fetchTransacoesPeriodo(
          start: meta.dataInicio,
          end: meta.dataFim,
        );

        double receitas = 0;
        double despesas = 0;
        for (final t in transacoes) {
          if (t.tipo.toLowerCase() == 'receita') {
            receitas += t.valor;
          } else {
            despesas += t.valor;
          }
        }

        setState(() {
          _metaAtiva = meta;
          _progressoAtual = receitas - despesas;
          _loading = false;
        });
      } else {
        setState(() {
          _metaAtiva = null;
          _progressoAtual = 0;
          _loading = false;
        });
      }
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
      child: InkWell(
        onTap: _metaAtiva != null ? () => _navigateToDetailPage(context) : null,
        borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Meta Financeira',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (_metaAtiva != null)
                      const Icon(Icons.chevron_right, size: 28, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                _buildContent(),
              ],
            ),
          ),
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context) {
    if (_metaAtiva != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalhesMetaPage(meta: _metaAtiva!),
        ),
      ).then((_) {
        _loadData(); // Recarrega quando retorna da página de detalhes
      });
    }
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Erro ao carregar meta'),
          Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _loadData,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    if (_metaAtiva == null) {
      return _NoGoalView(onCreateGoal: _navigateToCreateGoal);
    }

    return _GoalProgressView(
      meta: _metaAtiva!,
      progressoAtual: _progressoAtual,
    );
  }

  void _navigateToCreateGoal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CriarMetaPage()),
    );
    
    if (result != null) {
      _loadData();
    }
  }
}

class _NoGoalView extends StatelessWidget {
  final VoidCallback onCreateGoal;

  const _NoGoalView({required this.onCreateGoal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.flag_outlined,
          size: 48,
          color: Colors.grey,
        ),
        const SizedBox(height: 12),
        const Text(
          'Nenhuma meta ativa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Crie uma meta financeira para acompanhar seu progresso',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onCreateGoal,
          icon: const Icon(Icons.add),
          label: const Text('Criar Meta'),
        ),
      ],
    );
  }
}

class _GoalProgressView extends StatelessWidget {
  final MetaFinanceira meta;
  final double progressoAtual;

  const _GoalProgressView({
    required this.meta,
    required this.progressoAtual,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Calcula o status da meta
    final status = meta.getStatus(progressoAtual);
    final progressPercentage = meta.valor > 0 ? (progressoAtual / meta.valor).clamp(0.0, 1.0) : 0.0;
    final progressColor = MetaFinanceira.getColorForStatus(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (meta.descricao != null && meta.descricao!.isNotEmpty) ...[
          Text(
            meta.descricao!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meta: ${currency.format(meta.valor)}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Período: ${dateFormat.format(meta.dataInicio)} - ${dateFormat.format(meta.dataFim)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Barra de progresso
        LinearProgressIndicator(
          value: progressPercentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          minHeight: 8,
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Atual: ${currency.format(progressoAtual)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: progressColor,
              ),
            ),
            Text(
              '${(progressPercentage * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: progressColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Badge de status abaixo (centralizado)
        Center(
          child: MetaStatusBadge(
            status: status,
            progressoAtual: progressoAtual,
            valorMeta: meta.valor,
          ),
        ),
      ],
    );
  }
}

