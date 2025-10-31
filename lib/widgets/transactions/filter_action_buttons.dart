import 'package:flutter/material.dart';

class FilterActionButtons extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onFilter;

  const FilterActionButtons({
    super.key,
    required this.onClear,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onClear,
            child: const Text('Limpar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onFilter,
            child: const Text('Filtrar'),
          ),
        ),
      ],
    );
  }
}

