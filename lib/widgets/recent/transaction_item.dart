import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/models/transacao_model.dart';

class TransactionItem extends StatefulWidget {
  final Transacao transacao;

  const TransactionItem({super.key, required this.transacao});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final transacao = widget.transacao;
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy');

    final isReceita = transacao.tipo.toLowerCase() == 'receita';
    final color = isReceita ? Colors.green : Colors.red;
    final backgroundColor = color.withOpacity(0.1);
    final prefix = isReceita ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(transacao.data),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (transacao.descricao != null && transacao.descricao!.isNotEmpty)
                        Text(
                          transacao.descricao!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (transacao.estabelecimento != null && (transacao.estabelecimento!.nome != null && transacao.estabelecimento!.nome!.isNotEmpty))
                        Text(
                          'Estab.: ${transacao.estabelecimento!.nome!}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '$prefix ${currency.format(transacao.valor)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              AnimatedCrossFade(
                crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _Details(transacao: transacao, color: color),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final Transacao transacao;
  final Color color;

  const _Details({required this.transacao, required this.color});

  @override
  Widget build(BuildContext context) {
    final forma = transacao.formaPagamento;
    final est = transacao.estabelecimento;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tipo e recorrente
        Row(
          children: [
            const Text('Tipo: ', style: TextStyle(fontWeight: FontWeight.w600)),
            Text(transacao.tipo),
            const SizedBox(width: 12),
            const Text('Recorrente: ', style: TextStyle(fontWeight: FontWeight.w600)),
            Text(transacao.recorrente ? 'Sim' : 'Não'),
          ],
        ),
        // Forma de pagamento
        if (forma != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('Forma: ', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(forma.nome ?? 'ID: ${forma.id}'),
            ],
          ),
        ],
        // Estabelecimento (nome e categoria)
        if (est != null) ...[
          const SizedBox(height: 6),
          const Text('Estabelecimento', style: TextStyle(fontWeight: FontWeight.w600)),
          if (est.nome != null) Text('Nome: ${est.nome}'),
          if (est.categoria != null && est.categoria!.nome.isNotEmpty) Text('Categoria: ${est.categoria!.nome}'),
        ],
      ],
    );
  }
}


