import 'package:flutter/material.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/widgets/recent/transaction_item.dart';

class MetaTransactionsCard extends StatelessWidget {
  final bool loading;
  final String? error;
  final List<Transacao> transacoes;
  final VoidCallback onRetry;

  const MetaTransactionsCard({
    super.key,
    required this.loading,
    this.error,
    required this.transacoes,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Transações',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Erro ao carregar transações'),
          Text(error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    if (transacoes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('Nenhuma transação neste período'),
        ),
      );
    }

    return Column(
      children: transacoes.map((t) => TransactionItem(transacao: t)).toList(),
    );
  }
}
