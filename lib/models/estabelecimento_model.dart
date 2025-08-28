// To parse this JSON data, do
//
//     final estabelecimento = estabelecimentoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Estabelecimento estabelecimentoFromJson(String str) => Estabelecimento.fromJson(json.decode(str));

String estabelecimentoToJson(Estabelecimento data) => json.encode(data.toJson());

class Estabelecimento {
  final int id;
  final String? nome;
  final String? cnpj;
  final String? endereco;

  Estabelecimento({
    required this.id,
    this.nome,
    this.cnpj,
    this.endereco,
  });

  factory Estabelecimento.fromJson(Map<String, dynamic> json) => Estabelecimento(
    id: json["id"],
    nome: json["nome"],
    cnpj: json["cnpj"],
    endereco: json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "cnpj": cnpj,
    "descricao": endereco,
  };
}
