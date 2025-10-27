import 'package:flutter/material.dart';
import 'package:money_flow_app/pages/home_page.dart';

import '../controllers/user_controller.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // Cria usuário no backend
      await UserController().createUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Tenta logar automaticamente para obter token
      final token = await UserController().loginUser(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() => _loading = false);

      if (token != null && token.isNotEmpty) {
        _showSnack('Conta criada e logado');
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } else {
        _showSnack('Conta criada. Faça login para continuar.');
        if (mounted) Navigator.of(context).pop(); // volta para tela de login
      }
    } catch (e) {
      setState(() => _loading = false);
      _showSnack('Erro ao criar conta: ${e.toString()}');
    }
  }

  void _onHaveAccount() {
    Navigator.of(context).pop(); // volta para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Por favor insira seu nome';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Por favor insira seu email';
                  if (!v.contains('@')) return 'Digite um email válido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Por favor insira uma senha';
                  if (v.length < 6) return 'A senha deve ter ao menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Por favor confirme a senha';
                  if (v != _passwordController.text) return 'As senhas não correspondem';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _onSignup,
                  child: _loading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Criar conta'),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onHaveAccount,
                  child: const Text('Já tem conta? Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}