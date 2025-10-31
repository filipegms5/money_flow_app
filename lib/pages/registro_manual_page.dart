import 'package:flutter/material.dart';
import 'package:money_flow_app/pages/qr_code_page.dart';
import 'package:money_flow_app/widgets/registro_manual_form.dart';
import 'package:money_flow_app/widgets/liquid_glass_app_bar.dart';

class RegistroManualPage extends StatelessWidget {
  const RegistroManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiquidGlassAppBar(
        titleText: 'Registro Manual',
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrCodePage()),
              );
              if (result != null) {
                Navigator.pop(context, true);
              }
            },
            tooltip: 'Escanear QR Code',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: const RegistroManualForm(),
        ),
      ),
    );
  }
}

