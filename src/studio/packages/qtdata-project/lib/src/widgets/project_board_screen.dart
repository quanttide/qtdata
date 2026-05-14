import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanttide_project/quanttide_project.dart';
import 'package:flutter_quanttide_project/flutter_quanttide_project.dart';
import '../services/api_client.dart';
import '../bloc/board_bloc.dart';
import 'stage_column.dart';

class ProjectBoardScreen extends StatelessWidget {
  final ApiClient? apiClient;

  const ProjectBoardScreen({super.key, this.apiClient});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardBloc(api: apiClient)..add(LoadBoard()),
      child: _BoardView(),
    );
  }
}

class _BoardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (context, state) {
        switch (state) {
          case BoardInitial():
            return const Scaffold(
              body: Center(child: Text('')),
            );
          case BoardLoading():
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case BoardLoaded(:final board):
            final b = board!;
            return Scaffold(
              appBar: _buildAppBar(),
              body: BoardView(
                columns: [
                  (child: StageColumn(
                    icon: Icons.search_outlined,
                    title: '需求探索',
                    tasks: b.requirement,
                    cardBuilder: _buildCard,
                  ), flex: 1.2),
                  (child: StageColumn(
                    icon: Icons.description_outlined,
                    title: '约定启动',
                    tasks: b.agreement,
                    cardBuilder: _buildCard,
                  ), flex: 0.8),
                  (child: StageColumn(
                    icon: Icons.play_arrow_outlined,
                    title: '执行监控',
                    tasks: b.execution,
                    cardBuilder: _buildCard,
                  ), flex: 1.2),
                  (child: StageColumn(
                    icon: Icons.check_circle_outlined,
                    title: '验收交付',
                    tasks: b.acceptance,
                    cardBuilder: _buildCard,
                  ), flex: 0.8),
                ],
              ),
            );
          case BoardError(:final error):
            return Scaffold(
              appBar: _buildAppBar(),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('加载失败: $error'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<BoardBloc>().add(LoadBoard()),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('量潮数据'),
      centerTitle: true,
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
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
