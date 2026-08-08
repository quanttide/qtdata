import 'package:flutter/material.dart';

/// 项目状态徽章（已完成/进行中/待启动 三态配色）
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _bg {
    if (status == '已完成') return const Color(0xFFD1FAE5);
    if (status == '进行中') return const Color(0xFFDBEAFE);
    return const Color(0xFFFEF3C7);
  }

  Color get _fg {
    if (status == '已完成') return const Color(0xFF065F46);
    if (status == '进行中') return const Color(0xFF1D4ED8);
    return const Color(0xFF92400E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _fg),
      ),
    );
  }
}
