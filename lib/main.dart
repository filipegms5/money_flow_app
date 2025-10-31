import 'package:flutter/material.dart';
import 'package:money_flow_app/pages/home_page.dart';
import 'package:money_flow_app/pages/login_page.dart';
import 'package:money_flow_app/controllers/theme_controller.dart';
import 'package:money_flow_app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Página inicial',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.themeMode,
          home: LoginPage(themeController: _themeController),
        );
      },
    );
  }
}