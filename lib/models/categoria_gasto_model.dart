class CategoriaGasto {
  final int categoriaId;
  final String nome;
  final double total;

  CategoriaGasto({required this.categoriaId, required this.nome, required this.total});

  factory CategoriaGasto.fromJson(Map<String, dynamic> json) {
    return CategoriaGasto(
      categoriaId: json['categoria_id'] is String
          ? int.tryParse(json['categoria_id']) ?? 0
          : (json['categoria_id'] ?? 0) as int,
      nome: (json['nome'] ?? '').toString(),
      total: (json['total'] is int)
          ? (json['total'] as int).toDouble()
          : (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'categoria_id': categoriaId,
        'nome': nome,
        'total': total,
      };
}


