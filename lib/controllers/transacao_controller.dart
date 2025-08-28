import 'dart:convert';

import 'package:money_flow_app/models/transacao_model.dart';

import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;

class TransacoesController {

  Future<List<Transacao>> fetchTransacoes() async {
    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.transacoes}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // decodifica o JSON localmente
      final List<dynamic> jsonData = jsonDecode(response.body);

      final res = jsonData.map((e) => Transacao.fromJson(e)).toList();
      // converte para lista de Transacao
      return res;
    } else {
      throw Exception('Erro ao carregar transações: ${response.statusCode}');
    }
  }
}