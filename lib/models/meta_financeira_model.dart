
import 'package:meta/meta.dart';
import 'dart:convert';

MetaFinanceira metaFinanceiraFromJson(String str) => MetaFinanceira.fromJson(json.decode(str));

String metaFinanceiraToJson(MetaFinanceira data) => json.encode(data.toJson());

class MetaFinanceira {
  final int id;
  final double valor;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String? descricao;
  final bool ativa;

  MetaFinanceira({
    required this.id,
    required this.valor,
    required this.dataInicio,
    required this.dataFim,
    this.descricao,
    this.ativa = true,
  });

  factory MetaFinanceira.fromJson(Map<String, dynamic> json) => MetaFinanceira(
    id: json["id"],
    valor: json["valor"]?.toDouble(),
    dataInicio: DateTime.parse(json["data_inicio"]),
    dataFim: DateTime.parse(json["data_fim"]),
    descricao: json["descricao"],
    ativa: json["ativa"] ?? true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "valor": valor,
    "data_inicio": dataInicio.toIso8601String().substring(0, 10),
    "data_fim": dataFim.toIso8601String().substring(0, 10),
    if (descricao != null && descricao!.isNotEmpty) "descricao": descricao,
    "ativa": ativa,
  };
}

