import 'package:flutter/material.dart';
import 'package:quanttide_project/quanttide_project.dart';
import 'package:flutter_quanttide_project/flutter_quanttide_project.dart';
import '../data_board.dart';
import 'stage_column.dart';

class DataBoardScreen extends StatelessWidget {
  final DataBoard board;

  const DataBoardScreen({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('量潮数据'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
      ),
      body: BoardView(
        columns: [
          (child: StageColumn(
            icon: Icons.search_outlined,
            title: '需求探索',
            tasks: board.requirement,
            cardBuilder: _buildCard,
          ), flex: 1.2),
          (child: StageColumn(
            icon: Icons.description_outlined,
            title: '约定启动',
            tasks: board.agreement,
            cardBuilder: _buildCard,
          ), flex: 0.8),
          (child: StageColumn(
            icon: Icons.play_arrow_outlined,
            title: '执行监控',
            tasks: board.execution,
            cardBuilder: _buildCard,
          ), flex: 1.2),
          (child: StageColumn(
            icon: Icons.check_circle_outlined,
            title: '验收交付',
            tasks: board.acceptance,
            cardBuilder: _buildCard,
          ), flex: 0.8),
        ],
      ),
    );
  }

  Widget _buildCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE6E6E6)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1A1A))),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(task.description,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
          ],
        ],
      ),
    );
  }
}
