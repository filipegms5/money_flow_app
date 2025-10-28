import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/models/meta_financeira_model.dart';
import 'package:money_flow_app/models/transacao_model.dart';

class MetaInfoCard extends StatelessWidget {
  final MetaFinanceira meta;
  final List<Transacao> transacoes;

  const MetaInfoCard({
    super.key,
    required this.meta,
    required this.transacoes,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    // Calculate progress
    double receitas = 0;
    double despesas = 0;
    for (final t in transacoes) {
      if (t.tipo.toLowerCase() == 'receita') {
        receitas += t.valor;
      } else {
        despesas += t.valor;
      }
    }
    final progressoAtual = receitas - despesas;
    final progressPercentage = meta.valor > 0 
        ? (progressoAtual / meta.valor).clamp(0.0, 1.0) 
        : 0.0;
    final isPositive = progressoAtual >= 0;
    final progressColor = isPositive ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (meta.descricao != null && meta.descricao!.isNotEmpty) ...[
              Text(
                meta.descricao!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
            ],
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meta: ${currency.format(meta.valor)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            Text(
              'Período: ${dateFormat.format(meta.dataInicio)} - ${dateFormat.format(meta.dataFim)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            LinearProgressIndicator(
              value: progressPercentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 10,
            ),
            
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atual: ${currency.format(progressoAtual)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: progressColor,
                  ),
                ),
                Text(
                  '${(progressPercentage * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: progressColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
