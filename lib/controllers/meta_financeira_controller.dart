import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:money_flow_app/models/meta_financeira_model.dart';
import 'package:money_flow_app/models/transacao_model.dart';
import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;
import 'base_controller.dart';

class MetaFinanceiraController extends BaseController {

  Future<MetaFinanceira?> fetchMetaAtiva() async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.metaAtiva}');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData == null) return null;
      return MetaFinanceira.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null; // No active goal
    } else {
      throw Exception('Erro ao carregar meta ativa: ${response.statusCode}');
    }
  }

  Future<bool> createMeta(Map<String, dynamic> data) async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.metasFinanceiras}');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erro ao criar meta: ${response.statusCode}');
    }
  }

  Future<List<Transacao>> fetchTransacoesDaMeta(int metaId) async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.transacoesDaMeta(metaId)}');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      
      List<dynamic> transacoesList = [];
      
      if (jsonData is List) {
        transacoesList = jsonData;
      } else if (jsonData is Map) {
        // Backend returns {despesas: [...], receitas: [...]}
        if (jsonData.containsKey('despesas')) {
          transacoesList.addAll(jsonData['despesas'] as List);
        }
        if (jsonData.containsKey('receitas')) {
          transacoesList.addAll(jsonData['receitas'] as List);
        }
      } else {
        throw Exception('Formato de resposta inesperado: $jsonData');
      }
      
      return transacoesList.map((json) => Transacao.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar transações da meta: ${response.statusCode}');
    }
  }
}

