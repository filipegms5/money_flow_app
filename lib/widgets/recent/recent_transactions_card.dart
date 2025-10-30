import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/pages/all_transactions_page.dart';
import 'package:money_flow_app/widgets/recent/transaction_item.dart';

class RecentTransactionsCard extends StatefulWidget {
  const RecentTransactionsCard({super.key});

  @override
  State<RecentTransactionsCard> createState() => _RecentTransactionsCardState();
}

class _RecentTransactionsCardState extends State<RecentTransactionsCard> {
  final TransacoesController _controller = TransacoesController();
  bool _loading = true;
  String? _error;
  List<Transacao> _transacoes = [];

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
      final transacoes = await _controller.fetchTransacoesRecentes(4);

      setState(() {
        _transacoes = transacoes;
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
      child: InkWell(
        onTap: _transacoes.isNotEmpty ? () => _navigateToAllTransactions(context) : null,
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
                    'Transações Recentes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_transacoes.isNotEmpty)
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

  void _navigateToAllTransactions(BuildContext context) {
    if (_transacoes.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllTransactionsPage()),
      );
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
          const Text('Erro ao carregar transações'),
          Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _loadData,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    if (_transacoes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('Nenhuma transação encontrada'),
        ),
      );
    }

    return Column(
      children: _transacoes.map((t) => TransactionItem(transacao: t)).toList(),
    );
  }
}


