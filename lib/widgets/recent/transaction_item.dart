import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/models/transacao_model.dart';

class TransactionItem extends StatelessWidget {
  final Transacao transacao;

  const TransactionItem({super.key, required this.transacao});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dateFormat = DateFormat('dd/MM/yyyy');

    final isReceita = transacao.tipo.toLowerCase() == 'receita';
    final color = isReceita ? Colors.green : Colors.red;
    final backgroundColor = color.withOpacity(0.1);
    final prefix = isReceita ? '+' : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
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
      child: Row(
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
            ],
          ),
          Text(
            '$prefix ${currency.format(transacao.valor)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


