import 'dart:math';
import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final int progress;
  final double height;
  final bool animated;

  const ProgressBarWidget({
    super.key,
    required this.progress,
    this.height = 10,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 0,
          end: animated ? progress / 100.0 : progress / 100.0,
        ),
        duration: animated ? const Duration(milliseconds: 600) : Duration.zero,
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: max(0.0, min(1.0, value)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
