// To parse this JSON data, do
//
//     final transacao = transacaoFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:money_flow_app/models/estabelecimento_model.dart';
import 'dart:convert';

import 'package:money_flow_app/models/forma_pagamento_model.dart';

Transacao transacaoFromJson(String str) => Transacao.fromJson(json.decode(str));

String transacaoToJson(Transacao data) => json.encode(data.toJson());

class Transacao {
  final int id;
  final double valor;
  final DateTime data;
  final FormaPagamento formaPagamento;
  final Estabelecimento estabelecimento;

  Transacao({
    required this.id,
    required this.valor,
    required this.data,
    required this.formaPagamento,
    required this.estabelecimento,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) => Transacao(
    id: json["id"],
    valor: json["valor"]?.toDouble(),
    data: DateTime.parse(json["data"]),
    formaPagamento: FormaPagamento.fromJson(json["forma_pagamento"]),
    estabelecimento: Estabelecimento.fromJson(json["estabelecimento"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "valor": valor,
    "data": data.toIso8601String(),
    "forma_pagamento": formaPagamento,
    "estabelecimento": estabelecimento,
  };
}
