import 'dart:convert';

Categoria categoriaFromJson(String str) => Categoria.fromJson(json.decode(str));
String categoriaToJson(Categoria data) => json.encode(data.toJson());

class Categoria {
  final int id;
  final String nome;
  final String cnaeId;

  Categoria({
    required this.id,
    required this.nome,
    required this.cnaeId,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    id: json['id'],
    nome: json['nome'] ?? '',
    cnaeId: json['cnae_id'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'cnae_id': cnaeId,
  };
}

