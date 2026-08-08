import 'package:flutter/material.dart';
import '../models/project.dart';
import '../widgets/blueprint_card.dart';
import '../widgets/doc_dialog.dart';
import '../widgets/matrix_card.dart';
import '../widgets/phase_tag.dart';
import '../widgets/sidebar.dart';
import '../widgets/status_badge.dart';
import '../widgets/timeline_card.dart';
import '../widgets/toast.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Sidebar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头部
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                    child: _buildHeader(context),
                  ),
                  const SizedBox(height: 16),
                  // 内容区
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                      children: [
                        MatrixCard(matrix: project.matrix),
                        const SizedBox(height: 16),
                        BlueprintCard(blueprint: project.blueprint),
                        const SizedBox(height: 16),
                        TimelineCard(
                          phases: project.phases,
                          onViewDoc: (item) => _showDocDialog(context, item),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            '点击「查看资料」获取交付物文件',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 头部 =====
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.arrow_back, size: 20, color: Color(0xFF94A3B8)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  StatusBadge(status: project.status),
                  PhaseTag(phase: project.currentPhase),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '客户：${project.client} ｜ 创建于 ${project.created}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // 导出按钮
        InkWell(
          onTap: () => showAppToast(context, '📄 报告已导出'),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 14,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  '导出',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDocDialog(BuildContext context, PhaseItem item) =>
      showDocDialog(context, projectName: project.name, item: item);
}
