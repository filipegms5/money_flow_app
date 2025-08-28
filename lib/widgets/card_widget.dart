import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transacao_model.dart';

class CardWidget extends StatelessWidget {
   const CardWidget({super.key, required this.items, required this.index});
   final List<Transacao> items;
   final int index;

   @override
   Widget build(BuildContext context) {


     final String dataFormatada = DateFormat('dd/MM/yyyy').format(items[index].data);
     final String valorFormatado =
     NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(items[index].valor);


     return Card(
       elevation: 4,
       margin: const EdgeInsets.symmetric(vertical: 8),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
       ),
       child: ListTile(
         title: Text("Valor: $valorFormatado"),
         subtitle: Text('Compra Feita em $dataFormatada'),
         trailing: const Icon(Icons.arrow_forward_ios),
         onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Você clicou Numa Transação!')),
           );
         },
       ),
     );
   }
 }
