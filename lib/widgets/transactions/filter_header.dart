import 'package:flutter/material.dart';

class FilterHeader extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const FilterHeader({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ],
        ),
      ),
    );
  }
}

