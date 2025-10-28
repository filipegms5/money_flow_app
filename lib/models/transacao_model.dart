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
  final String tipo;
  final String? descricao;
  final bool recorrente;
  final FormaPagamento? formaPagamento;
  final Estabelecimento? estabelecimento;

  Transacao({
    required this.id,
    required this.valor,
    required this.data,
    required this.tipo,
    this.descricao,
    this.recorrente = false,
    this.formaPagamento,
    this.estabelecimento,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) => Transacao(
    id: json["id"],
    valor: json["valor"]?.toDouble(),
    data: DateTime.parse(json["data"]),
    tipo: json["tipo"] ?? "despesa",
    descricao: json["descricao"],
    recorrente: json["recorrente"] ?? false,
    formaPagamento: json["forma_pagamento"] != null
        ? FormaPagamento.fromJson(json["forma_pagamento"])
        : null,
    estabelecimento: json["estabelecimento"] != null
        ? Estabelecimento.fromJson(json["estabelecimento"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "valor": valor,
    "data": data.toIso8601String().substring(0, 10),
    "tipo": tipo,
    if (descricao != null && descricao!.isNotEmpty) "descricao": descricao,
    "recorrente": recorrente,
    if (formaPagamento != null) "forma_pagamento": formaPagamento!.toJson(),
    if (estabelecimento != null) "estabelecimento": estabelecimento!.toJson(),
  };
}
