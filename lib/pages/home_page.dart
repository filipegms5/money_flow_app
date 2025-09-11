import 'package:flutter/material.dart';
import 'package:money_flow_app/pages/listagem_despesas_page.dart';
import 'package:money_flow_app/pages/qr_code_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Key listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagem Despesas'), automaticallyImplyLeading: false,),
      body: ListagemDespesasPage(key: listKey),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrCodePage()),
          );

          if (result != null) {
            // Cria uma nova Key para forçar rebuild do widget filho
            setState(() {
              listKey = UniqueKey();
            });
          }
        },
        tooltip: 'Nova Transação',
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}