import 'package:flutter/material.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/widgets/recent/transaction_item.dart';

class TransactionsListCard extends StatelessWidget {
  final bool loading;
  final String? error;
  final List<Transacao> transactions;
  final VoidCallback onRetry;

  const TransactionsListCard({
    super.key,
    required this.loading,
    this.error,
    required this.transactions,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: const Padding(
          padding: EdgeInsets.all(40.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (error != null) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erro: $error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (transactions.isEmpty) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: const Padding(
          padding: EdgeInsets.all(40.0),
          child: Center(child: Text('Nenhuma transação encontrada')),
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TransactionItem(transacao: transactions[index]),
          );
        },
      ),
    );
  }
}

