import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controlador responsável por gerenciar o estado do tema da aplicação
/// Permite alternar entre tema claro e escuro, salvando a preferência
class ThemeController extends ChangeNotifier {
  /// Chave para salvar a preferência do tema no SharedPreferences
  static const String _themeKey = 'theme_mode';
  
  /// Modo atual do tema (padrão: escuro)
  ThemeMode _themeMode = ThemeMode.dark;
  
  /// Retorna o modo atual do tema
  ThemeMode get themeMode => _themeMode;
  
  /// Retorna true se o tema atual for escuro
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeController() {
    _loadTheme();
  }
  
  /// Carrega o tema salvo do SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
        notifyListeners();
      }
    } catch (e) {
      // Usa o tema escuro como padrão se houver erro ao carregar
      _themeMode = ThemeMode.dark;
    }
  }
  
  /// Define o modo do tema e salva a preferência
  /// 
  /// [mode] - O modo do tema a ser definido (claro ou escuro)
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _themeKey,
        mode == ThemeMode.dark ? 'dark' : 'light',
      );
    } catch (e) {
      // Ignora erros ao salvar
    }
  }
  
  /// Alterna entre tema claro e escuro
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

