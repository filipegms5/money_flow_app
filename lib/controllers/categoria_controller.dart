import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:money_flow_app/models/categoria_model.dart';
import 'package:money_flow_app/utils/endpoints.dart';

import 'base_controller.dart';

class CategoriaController extends BaseController {
  Future<List<Categoria>> fetchCategorias() async {
    await ensureInitialized();

    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.categorias}');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Categoria.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar categorias: ${response.statusCode}');
    }
  }
}

