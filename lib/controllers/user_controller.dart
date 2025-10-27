import 'dart:convert';

import 'package:money_flow_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;

class UserController {

  Future<User> createUser(String nome, String email, String senha) async {
    User user = User(nome: nome,senha: senha,email: email);
    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.createUser}');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),);

    if (response.statusCode == 201) {
      return user;
    }else{
      throw Exception('Erro: ${response.statusCode}');
    }

  }

  Future<String?> loginUser(String email, String senha) async {
    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.loginUser}');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senha}),);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String? token = data['token']?.toString();

      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }

      return token;
    }else{
      if(response.statusCode == 401){
        throw Exception('Email ou senha incorretos.');
      }
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  // Recupera token salvo
  static Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Opcional: remover token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}