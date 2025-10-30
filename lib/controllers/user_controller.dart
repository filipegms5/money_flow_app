import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:money_flow_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/endpoints.dart';
import 'package:http/http.dart' as http;

class UserController {

  Future<User> createUser(String nome, String email, String senha) async {
    User user = User(nome: nome,senha: senha,email: email);
    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.createUser}');

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(user.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return user;
      } else {
        throw Exception('Erro: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Tempo esgotado ao comunicar com o servidor. Tente novamente.');
    } on SocketException {
      throw Exception('Não foi possível conectar ao servidor. Verifique sua conexão.');
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  Future<String?> loginUser(String email, String senha) async {
    final url = Uri.parse('${Endpoint.baseURL}${Endpoint.loginUser}');

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "senha": senha}),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String? token = data['token']?.toString();

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }

        return token;
      } else {
        if (response.statusCode == 401) {
          throw Exception('Email ou senha incorretos.');
        }
        throw Exception('Erro: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Tempo esgotado ao tentar entrar. Verifique sua conexão e tente novamente.');
    } on SocketException {
      throw Exception('Servidor indisponível ou sem conexão. Tente novamente mais tarde.');
    } catch (e) {
      throw Exception('Erro ao realizar login: $e');
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