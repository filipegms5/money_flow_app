
import 'package:meta/meta.dart';
import 'dart:convert';

FormaPagamento formaPagamentoFromJson(String str) => FormaPagamento.fromJson(json.decode(str));

String formaPagamentoToJson(FormaPagamento data) => json.encode(data.toJson());

class FormaPagamento {
  final int id;
  final String? nome;

  FormaPagamento({
    required this.id,
    this.nome,
  });

  factory FormaPagamento.fromJson(Map<String, dynamic> json) => FormaPagamento(
    id: json["id"],
    nome: json["nome"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
  };
}
