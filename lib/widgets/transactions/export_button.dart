import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/export_controller.dart';
import 'package:money_flow_app/models/transacao_model.dart';

class ExportButton extends StatefulWidget {
  final List<Transacao> transacoes;

  const ExportButton({
    super.key,
    required this.transacoes,
  });

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  bool _isExporting = false;
  final ExportController _controller = ExportController();

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      await _controller.exportAndShare(widget.transacoes, context);
    } catch (e) {
      // Erro já tratado no controller
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: _isExporting
          ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : IconButton(
              icon: const Icon(Icons.download),
              onPressed: _handleExport,
              tooltip: 'Exportar para Excel',
            ),
    );
  }
}
