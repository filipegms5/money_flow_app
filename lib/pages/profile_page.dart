import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/user_controller.dart';
import 'package:money_flow_app/controllers/theme_controller.dart';
import 'package:money_flow_app/pages/login_page.dart';
import 'package:money_flow_app/widgets/liquid_glass_app_bar.dart';
import 'package:money_flow_app/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  final ThemeController themeController;
  
  const ProfilePage({super.key, required this.themeController});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await UserController.logoutUser();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage(themeController: themeController)),
          (route) => false, // Remove todas as rotas anteriores
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer logout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, child) {
        return Scaffold(
          appBar: const LiquidGlassAppBar(
            titleText: 'Perfil',
          ),
          body: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Editar Perfil'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Placeholder - sem funcionalidade ainda
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Tema Escuro'),
                      trailing: Switch(
                        value: themeController.isDarkMode,
                        onChanged: (value) {
                          themeController.toggleTheme();
                        },
                      ),
                    ),
                    const Divider(height: 1),
                ListTile(
                  title: const Text('Notificações'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Placeholder - sem funcionalidade ainda
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Sobre'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Placeholder - sem funcionalidade ainda
                  },
                ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 66.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.getColors(context).buttonDanger,
                      foregroundColor: AppTheme.getColors(context).buttonDangerText,
                    ),
                    child: const Text('Sair'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

