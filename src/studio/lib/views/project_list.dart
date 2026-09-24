import 'package:flutter/material.dart';

import '../models/project.dart';
import 'project_card.dart';

/// 项目列表：加载中 / 加载失败 / 无匹配 / 有数据四种态
class ProjectList extends StatelessWidget {
  final List<Project> projects;
  final bool loading;
  final bool loadFailed;
  final ValueChanged<Project> onOpen;

  const ProjectList({
    super.key,
    required this.projects,
    required this.loading,
    required this.loadFailed,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (loadFailed) {
      return const Center(
        child: Text('种子数据加载失败', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (projects.isEmpty) {
      return const Center(
        child: Text('暂无匹配的项目', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }
    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(project: project, onTap: () => onOpen(project));
      },
    );
  }
}
