import 'package:flutter/material.dart';

class MonthBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;

  const MonthBar({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight * value;
          return Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}


