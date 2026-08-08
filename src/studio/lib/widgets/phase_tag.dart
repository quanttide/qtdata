import 'package:flutter/material.dart';
import '../models/project.dart';

/// 阶段标签（五阶段语义配色）
class PhaseTag extends StatelessWidget {
  final ProjectPhase phase;

  /// 卡片场景显示「实施阶段」而非「实施」
  final bool withSuffix;

  const PhaseTag({super.key, required this.phase, this.withSuffix = false});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (phase) {
      ProjectPhase.research => (
        const Color(0xFFDBEAFE),
        const Color(0xFF1D4ED8),
      ),
      ProjectPhase.negotiate => (
        const Color(0xFFFEF3C7),
        const Color(0xFF92400E),
      ),
      ProjectPhase.implement => (
        const Color(0xFFD1FAE5),
        const Color(0xFF065F46),
      ),
      ProjectPhase.accept => (const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
      ProjectPhase.review => (const Color(0xFFFCE7F3), const Color(0xFF9D174D)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        withSuffix ? '${phase.label}阶段' : phase.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}
