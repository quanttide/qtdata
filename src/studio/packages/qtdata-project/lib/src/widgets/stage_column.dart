import 'package:flutter/material.dart';
import 'package:quanttide_project/quanttide_project.dart';
import 'package:flutter_quanttide_project/flutter_quanttide_project.dart';
import 'board_column_title.dart';

class StageColumn extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Task> tasks;
  final Widget Function(Task task) cardBuilder;

  const StageColumn({
    super.key,
    required this.icon,
    required this.title,
    required this.tasks,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BoardColumn(
      title: BoardColumnTitle(
        icon: icon,
        title: title,
        count: '${tasks.length} 项',
      ),
      content: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
        children: [
          if (tasks.isEmpty)
            const _DashedPlaceholder()
          else
            ...tasks.map((t) => cardBuilder(t)),
        ],
      ),
    );
  }
}

class _DashedPlaceholder extends StatelessWidget {
  const _DashedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        height: 72,
        alignment: Alignment.center,
        child: const Text(
          '暂无任务',
          style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0D0D0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rect = Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + 6.0).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
