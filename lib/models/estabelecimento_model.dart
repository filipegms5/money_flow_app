
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:money_flow_app/models/categoria_model.dart';

Estabelecimento estabelecimentoFromJson(String str) => Estabelecimento.fromJson(json.decode(str));

String estabelecimentoToJson(Estabelecimento data) => json.encode(data.toJson());

class Estabelecimento {
  final int id;
  final String? nome;
  final String? cnpj;
  final String? endereco;
  final Categoria? categoria;

  Estabelecimento({
    required this.id,
    this.nome,
    this.cnpj,
    this.endereco,
    this.categoria,
  });

  factory Estabelecimento.fromJson(Map<String, dynamic> json) => Estabelecimento(
    id: json["id"],
    nome: json["nome"],
    cnpj: json["cnpj"],
    endereco: json["descricao"],
    categoria: json["categoria"] != null ? Categoria.fromJson(json["categoria"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "cnpj": cnpj,
    "descricao": endereco,
    if (categoria != null) "categoria": categoria!.toJson(),
  };
}
