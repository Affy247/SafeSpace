// lib/widgets/emotion_indicator.dart
import 'package:flutter/material.dart';

class EmotionIndicator extends StatelessWidget {
  final String mood;
  final double size;

  const EmotionIndicator({super.key, required this.mood, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          mood,
          style: TextStyle(fontSize: size * 0.6),
        ),
      ),
    );
  }
}
