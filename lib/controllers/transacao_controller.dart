import 'dart:convert';

import 'package:money_flow_app/models/transacao_model.dart';
import 'package:money_flow_app/models/forma_pagamento_model.dart';
import 'package:money_flow_app/models/estabelecimento_model.dart';

import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;

import 'base_controller.dart';

class TransacoesController extends BaseController {

  Future<List<Transacao>> fetchTransacoes() async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.transacoes}${Endpoint.usuario}');
    final response = await http.get(url, headers: headers);

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

  Future<bool> createTransacao(Map<String, dynamic> data) async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.transacoes}');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erro ao criar transação: ${response.statusCode}');
    }
  }

  Future<List<FormaPagamento>> fetchFormasPagamento() async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.formasPagamento}/qtd/4');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => FormaPagamento.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar formas de pagamento: ${response.statusCode}');
    }
  }

  Future<List<Estabelecimento>> fetchEstabelecimentos() async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.estabelecimentos}');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Estabelecimento.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar estabelecimentos: ${response.statusCode}');
    }
  }
}