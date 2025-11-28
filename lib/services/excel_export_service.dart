import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import 'package:path_provider/path_provider.dart';

class ExcelExportService {
  Future<String> exportTransacoesToExcel(List<Transacao> transacoes) async {
    // Criar Excel
    var excel = Excel.createExcel();
    var sheet = excel['Transações'];

    // Definir headers
    final headers = [
      'Data',
      'Tipo',
      'Valor',
      'Descrição',
      'Categoria',
      'Estabelecimento',
      'Forma Pagamento',
      'Recorrente'
    ];

    // Adicionar headers com estilo
    for (var i = 0; i < headers.length; i++) {
      var cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = _createHeaderStyle();
    }

    // Adicionar dados
    for (var i = 0; i < transacoes.length; i++) {
      final t = transacoes[i];
      final row = i + 1;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(_formatDate(t.data));

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(t.tipo == 'receita' ? 'Receita' : 'Despesa');

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(_formatCurrency(t.valor));

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(t.descricao ?? '-');

      final categoriaNome =
          t.categoria?.nome ?? t.estabelecimento?.categoria?.nome ?? '-';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = TextCellValue(categoriaNome);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
          .value = TextCellValue(t.estabelecimento?.nome ?? '-');

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
          .value = TextCellValue(t.formaPagamento?.nome ?? '-');

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
          .value = TextCellValue(t.recorrente ? 'Sim' : 'Não');
    }

    // Adicionar linha de totais
    final totals = _calculateTotals(transacoes);
    final totalsRow = transacoes.length + 2;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: totalsRow))
        .value = TextCellValue('TOTAIS');

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: totalsRow))
        .value = TextCellValue(
            'Receitas: ${_formatCurrency(totals['receitas']!)}');

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: totalsRow))
        .value =
        TextCellValue('Despesas: ${_formatCurrency(totals['despesas']!)}');

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: totalsRow))
        .value = TextCellValue('Saldo: ${_formatCurrency(totals['saldo']!)}');

    // Ajustar largura das colunas
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 20);
    }

    // Salvar arquivo
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${directory.path}/transacoes_$timestamp.xlsx';

    final fileBytes = excel.save();
    final file = File(filePath);
    await file.writeAsBytes(fileBytes!);

    return filePath;
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  CellStyle _createHeaderStyle() {
    return CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#4A90E2'),
      fontColorHex: ExcelColor.white,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );
  }

  Map<String, double> _calculateTotals(List<Transacao> transacoes) {
    double receitas = 0;
    double despesas = 0;

    for (var t in transacoes) {
      if (t.tipo == 'receita') {
        receitas += t.valor;
      } else {
        despesas += t.valor;
      }
    }

    return {
      'receitas': receitas,
      'despesas': despesas,
      'saldo': receitas - despesas,
    };
  }
}
