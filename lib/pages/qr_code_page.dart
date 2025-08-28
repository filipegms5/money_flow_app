import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:money_flow_app/controllers/qr_code_controller.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

final QrCodeController qrCodeController = QrCodeController();

class _QrCodePageState extends State<QrCodePage> {
  String? scannedCode;
  bool _isScanned = false; // evita múltiplas leituras

  Future<void> _postarQrCode(code) async{
    await qrCodeController.postQrCode(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear QR Code"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (barcode) {
                if (_isScanned) return; // bloqueia leitura duplicada
                final String? code = barcode.barcodes.first.rawValue;
                if (code != null) {
                  setState(() {
                    _postarQrCode(code);
                    scannedCode = code;
                    _isScanned = true;
                  });


                  // Fecha a tela e retorna o código lido
                  Navigator.pop(context, code);
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedCode ?? "Aponte a câmera para um QR Code",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
