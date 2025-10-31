import 'package:flutter/material.dart';

class DescriptionFilterField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const DescriptionFilterField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Descrição',
        hintText: 'Buscar por descrição',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

