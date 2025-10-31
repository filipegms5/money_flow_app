import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/controllers/categoria_controller.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/models/categoria_model.dart';
import 'package:money_flow_app/widgets/transactions/transactions_filter_card.dart';
import 'package:money_flow_app/widgets/transactions/transactions_list_card.dart';
import 'package:money_flow_app/widgets/liquid_glass_app_bar.dart';

class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  final TransacoesController _controller = TransacoesController();
  final CategoriaController _categoriaController = CategoriaController();

  bool _loading = true;
  String? _error;
  List<Transacao> _transacoes = [];
  List<Transacao> _filteredTransacoes = [];

  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _loadAllTransactions();
    _loadCategorias();
  }


  Future<void> _loadCategorias() async {
    try {
      final categorias = await _categoriaController.fetchCategorias();
      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      // Handle error silently or show snackbar if needed
    }
  }

  Future<void> _loadAllTransactions() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final transacoes = await _controller.fetchTransacoes();
      setState(() {
        _transacoes = transacoes;
        _filteredTransacoes = transacoes;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _applyFilter(DateTime? startDate, DateTime? endDate, String descriptionText, Categoria? categoria) {
    setState(() {
      _filteredTransacoes = _transacoes.where((t) {
        // Date filter
        bool dateMatch = true;
        if (startDate != null && endDate != null) {
          dateMatch = t.data.isAfter(startDate.subtract(const Duration(days: 1))) &&
                      t.data.isBefore(endDate.add(const Duration(days: 1)));
        }

        // Description filter
        bool descriptionMatch = true;
        final description = descriptionText.toLowerCase();
        if (description.isNotEmpty) {
          final transacaoDescricao = t.descricao?.toLowerCase() ?? '';
          descriptionMatch = transacaoDescricao.contains(description);
        }

        // Category filter
        bool categoryMatch = true;
        if (categoria != null) {
          final transacaoCategoriaId = t.categoria?.id ?? t.estabelecimento?.categoria?.id;
          categoryMatch = transacaoCategoriaId == categoria.id;
        } else {
          // If "Todas" is selected (null), include all transactions including those without category
          categoryMatch = true;
        }

        return dateMatch && descriptionMatch && categoryMatch;
      }).toList();
    });
  }

  void _clearFilter() {
    setState(() {
      _filteredTransacoes = _transacoes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LiquidGlassAppBar(
        titleText: 'Todas as Transações',
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Column(
          children: [
            TransactionsFilterCard(
              categorias: _categorias,
              onFilterApply: _applyFilter,
              onFilterClear: _clearFilter,
            ),
            Expanded(
              child: TransactionsListCard(
                loading: _loading,
                error: _error,
                transactions: _filteredTransacoes,
                onRetry: _loadAllTransactions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
