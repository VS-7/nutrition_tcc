import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double currentValue;
  final double goalValue;
  final Color foregroundColor;
  final Color backgroundColor;
  final String label;

  const CircularProgressIndicatorWidget(
    this.currentValue,
    this.goalValue,
    this.foregroundColor,
    this.backgroundColor,
    this.label, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentValue / goalValue;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 75,
              height: 75,
              child: CircularProgressIndicator(
                value: (progress > 1) ? 1 : progress,
                backgroundColor: backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                strokeWidth: 6,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${currentValue.toInt()} / ${goalValue.toInt()}g',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}