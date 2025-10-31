import 'package:flutter/material.dart';
import 'package:money_flow_app/widgets/criar_meta_form.dart';
import 'package:money_flow_app/widgets/liquid_glass_app_bar.dart';

class CriarMetaPage extends StatelessWidget {
  const CriarMetaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LiquidGlassAppBar(
        titleText: 'Criar Meta Financeira',
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const CriarMetaForm(),
            ),
          ),
        ),
      ),
    );
  }
}

