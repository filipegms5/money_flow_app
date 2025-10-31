import 'package:flutter/material.dart';
import 'package:money_flow_app/models/categoria_model.dart';

class CategoryFilterField extends StatelessWidget {
  final Categoria? selectedCategoria;
  final List<Categoria> categorias;
  final Function(Categoria?) onChanged;

  const CategoryFilterField({
    super.key,
    required this.selectedCategoria,
    required this.categorias,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Categoria?>(
      value: selectedCategoria,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: [
        const DropdownMenuItem<Categoria?>(
          value: null,
          child: Text('Todas'),
        ),
        ...categorias.map((categoria) {
          return DropdownMenuItem<Categoria?>(
            value: categoria,
            child: Text(categoria.nome),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }
}

