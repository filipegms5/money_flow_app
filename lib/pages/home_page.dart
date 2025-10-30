import 'package:flutter/material.dart';
import 'package:money_flow_app/widgets/overview/overview_receita_despesa_card.dart';
import 'package:money_flow_app/widgets/recent/recent_transactions_card.dart';
import 'package:money_flow_app/widgets/goal/meta_financeira_card.dart';
import 'package:money_flow_app/widgets/category/category_spending_card.dart';
import 'package:money_flow_app/pages/qr_code_page.dart';
import 'package:money_flow_app/pages/registro_manual_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Key _overviewCardKey = UniqueKey();
  Key _recentTransactionsKey = UniqueKey();
  Key _metaCardKey = UniqueKey();
  Key _categorySpendingKey = UniqueKey();

  Future<void> _openPage(Widget page) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (result != null) {
      // Cria uma nova Key para forçar rebuild dos widgets
      setState(() {
        _overviewCardKey = UniqueKey();
        _categorySpendingKey = UniqueKey();
        _recentTransactionsKey = UniqueKey();
        _metaCardKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              OverviewReceitaDespesaCard(key: _overviewCardKey),
              const SizedBox(height: 16),
              CategorySpendingCard(key: _categorySpendingKey),
              const SizedBox(height: 16),
              MetaFinanceiraCard(key: _metaCardKey),
              const SizedBox(height: 16),
              RecentTransactionsCard(key: _recentTransactionsKey),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'qr':
                _openPage(const QrCodePage());
                break;
              case 'manual':
                _openPage(const RegistroManualPage());
                break;
            }
          },
          tooltip: 'Nova Transação',
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Icon(Icons.add, color: Colors.blue),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'qr',
              child: ListTile(
                leading: Icon(Icons.qr_code),
                title: Text('Escanear QR Code'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'manual',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Registro Manual'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}