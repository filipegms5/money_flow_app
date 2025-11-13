import 'package:flutter/material.dart';
import 'package:money_flow_app/models/meta_financeira_model.dart';

class MetaStatusBadge extends StatelessWidget {
  final MetaStatus status;
  final double progressoAtual;
  final double valorMeta;

  const MetaStatusBadge({
    super.key,
    required this.status,
    required this.progressoAtual,
    required this.valorMeta,
  });

  @override
  Widget build(BuildContext context) {
    final color = MetaFinanceira.getColorForStatus(status);
    final icon = MetaFinanceira.getIconForStatus(status);
    final label = MetaFinanceira.getStatusLabel(status);
    final message = MetaFinanceira.getMessageForStatus(status, progressoAtual, valorMeta);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      color: color.withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
