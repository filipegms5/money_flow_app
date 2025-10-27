import 'package:money_flow_app/controllers/user_controller.dart';

/// Controller base que inicializa headers (ex.: Authorization) assincronamente
abstract class BaseController {
  late Future<void> _initialized;
  late Map<String, String> _headers;

  BaseController() {
    _initialized = _init();
  }

  // inicialização assíncrona que lê o token e monta os headers
  Future<void> _init() async {
    final token = await UserController.getStoredToken();
    _headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // garante que a inicialização terminou
  Future<void> ensureInitialized() => _initialized;

  // expõe headers para subclasses
  Map<String, String> get headers => _headers;

  // força refresh dos headers (ex.: após login/logout)
  Future<void> refreshHeaders() async {
    _initialized = _init();
    await _initialized;
  }
}