import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/transacao_controller.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/widgets/card_widget.dart';

class ListagemDespesasPage extends StatefulWidget {
  const ListagemDespesasPage({super.key});

  @override
  State<ListagemDespesasPage> createState() => _ListagemDespesasPageState();
}

final TransacoesController transacoesController = TransacoesController();
List<Transacao> listaTransacao = [];
bool carregando = true; // flag para controle

class _ListagemDespesasPageState extends State<ListagemDespesasPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarTransacoes();
  }

  // Função separada para carregar os dados
  Future<void> _carregarTransacoes() async {
    try {
      final transacoes = await transacoesController.fetchTransacoes();
      setState(() {
        listaTransacao = transacoes;
        carregando = false; // terminou de carregar
      });
    } catch (e) {
      setState(() {
        carregando = false;
      });
      debugPrint("Erro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (listaTransacao.isEmpty) {
      return const Center(child: Text('Nenhuma transação encontrada.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: listaTransacao.length,
      itemBuilder: (context, index) {
        return CardWidget(items: listaTransacao, index:index);
      },
    );
  }
}
