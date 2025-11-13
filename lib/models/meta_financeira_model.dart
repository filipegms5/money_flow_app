
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

MetaFinanceira metaFinanceiraFromJson(String str) => MetaFinanceira.fromJson(json.decode(str));

String metaFinanceiraToJson(MetaFinanceira data) => json.encode(data.toJson());

enum MetaStatus {
  naoIniciada,
  emAndamento,
  atingida,
  falhou,
}

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

  // Calcula o status da meta baseado no progresso atual e datas
  MetaStatus getStatus(double progressoAtual) {
    final agora = DateTime.now();

    if (agora.isBefore(dataInicio)) {
      return MetaStatus.naoIniciada;
    }

    if (progressoAtual >= valor) {
      return MetaStatus.atingida;
    }

    if (agora.isAfter(dataFim)) {
      return MetaStatus.falhou;
    }

    return MetaStatus.emAndamento;
  }

  // Helpers estáticos para o status
  static Color getColorForStatus(MetaStatus status) {
    switch (status) {
      case MetaStatus.atingida:
        return Colors.green;
      case MetaStatus.falhou:
        return Colors.red;
      case MetaStatus.emAndamento:
        return Colors.blue;
      case MetaStatus.naoIniciada:
        return Colors.grey;
    }
  }

  static IconData getIconForStatus(MetaStatus status) {
    switch (status) {
      case MetaStatus.atingida:
        return Icons.check_circle;
      case MetaStatus.falhou:
        return Icons.cancel;
      case MetaStatus.emAndamento:
        return Icons.trending_up;
      case MetaStatus.naoIniciada:
        return Icons.schedule;
    }
  }

  static String getMessageForStatus(MetaStatus status, double progressoAtual, double valorMeta) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

    switch (status) {
      case MetaStatus.atingida:
        return '🎉 Parabéns! Meta atingida!';
      case MetaStatus.falhou:
        return 'Meta não atingida. Continue tentando!';
      case MetaStatus.emAndamento:
        final falta = valorMeta - progressoAtual;
        if (falta > 0) {
          return 'Faltam ${currency.format(falta)} para atingir a meta';
        } else {
          return 'Você está no caminho certo!';
        }
      case MetaStatus.naoIniciada:
        return 'Meta ainda não iniciada';
    }
  }

  static String getStatusLabel(MetaStatus status) {
    switch (status) {
      case MetaStatus.atingida:
        return 'Meta Atingida';
      case MetaStatus.falhou:
        return 'Meta Não Atingida';
      case MetaStatus.emAndamento:
        return 'Em Andamento';
      case MetaStatus.naoIniciada:
        return 'Não Iniciada';
    }
  }
}
