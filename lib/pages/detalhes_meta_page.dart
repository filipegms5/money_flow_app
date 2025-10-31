import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/meta_financeira_controller.dart';
import 'package:money_flow_app/models/meta_financeira_model.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/pages/criar_meta_page.dart';
import 'package:money_flow_app/widgets/goal_detail/create_meta_button.dart';
import 'package:money_flow_app/widgets/goal_detail/meta_info_card.dart';
import 'package:money_flow_app/widgets/goal_detail/meta_transactions_card.dart';
import 'package:money_flow_app/widgets/liquid_glass_app_bar.dart';

class DetalhesMetaPage extends StatefulWidget {
  final MetaFinanceira meta;

  const DetalhesMetaPage({super.key, required this.meta});

  @override
  State<DetalhesMetaPage> createState() => _DetalhesMetaPageState();
}

class _DetalhesMetaPageState extends State<DetalhesMetaPage> {
  final MetaFinanceiraController _controller = MetaFinanceiraController();
  
  bool _loading = true;
  String? _error;
  List<Transacao> _transacoes = [];

  @override
  void initState() {
    super.initState();
    _loadTransacoes();
  }

  Future<void> _loadTransacoes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final transacoes = await _controller.fetchTransacoesDaMeta(widget.meta.id);
      
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

  Future<void> _createNovaMeta() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CriarMetaPage()),
    );

    if (result != null) {
      // Retorna para a home com sinal de atualização
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiquidGlassAppBar(
        titleText: 'Detalhes da Meta',
        actions: [
          CreateMetaButton(onPressed: _createNovaMeta),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MetaInfoCard(
              meta: widget.meta,
              transacoes: _transacoes,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: MetaTransactionsCard(
                loading: _loading,
                error: _error,
                transacoes: _transacoes,
                onRetry: _loadTransacoes,
              ),
            ),
          ),
        ],
      ),
    );
  }
}