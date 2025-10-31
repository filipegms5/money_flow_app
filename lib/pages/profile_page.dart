import 'package:flutter/material.dart';
import 'package:money_flow_app/controllers/user_controller.dart';
import 'package:money_flow_app/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await UserController.logoutUser();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
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
                  title: const Text('Configurações'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Placeholder - sem funcionalidade ainda
                  },
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
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sair'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

