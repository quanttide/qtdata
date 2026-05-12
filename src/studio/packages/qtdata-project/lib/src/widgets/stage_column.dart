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
        children: tasks.map((t) => cardBuilder(t)).toList(),
      ),
    );
  }
}
