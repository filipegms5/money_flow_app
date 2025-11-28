import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/services/excel_export_service.dart';
import 'package:money_flow_app/utils/snackbar_helper.dart';
import 'package:share_plus/share_plus.dart';

class ExportController {
  final ExcelExportService _excelService = ExcelExportService();

  Future<void> exportAndShare(
    List<Transacao> transacoes,
    BuildContext context,
  ) async {
    try {
      // Validar se há transações
      if (transacoes.isEmpty) {
        if (context.mounted) {
          SnackBarHelper.showError(context, 'Não há transações para exportar');
        }
        return;
      }

      // Gerar arquivo Excel
      final filePath = await _excelService.exportTransacoesToExcel(transacoes);

      // Compartilhar arquivo
      await _shareFile(filePath);

      // Mostrar mensagem de sucesso
      if (context.mounted) {
        SnackBarHelper.showSuccess(
          context,
          'Arquivo Excel gerado com sucesso!',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(
          context,
          'Erro ao gerar arquivo. Tente novamente.',
        );
      }
      rethrow;
    }
  }

  Future<void> _shareFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Arquivo não encontrado');
    }

    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Transações - Money Flow',
      text: 'Exportação de transações do Money Flow App',
    );
  }
}
