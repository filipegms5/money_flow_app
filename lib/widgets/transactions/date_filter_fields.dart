import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilterFields extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Future<void> Function() onStartDateSelected;
  final Future<void> Function() onEndDateSelected;

  const DateFilterFields({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => onStartDateSelected(),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'De',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    startDate != null ? dateFormat.format(startDate!) : 'Selecione',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Icon(Icons.calendar_today, size: 20),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => onEndDateSelected(),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Até',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    endDate != null ? dateFormat.format(endDate!) : 'Selecione',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Icon(Icons.calendar_today, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

