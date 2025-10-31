import 'package:flutter/material.dart';
import 'package:money_flow_app/widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = screenHeight * 0.12; // ~25% abaixo do topo (onde estava AppBar ~56px)
    
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: topPadding),
          const Center(
            child: Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: const SignupForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}