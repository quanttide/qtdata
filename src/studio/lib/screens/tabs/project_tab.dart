import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/cards/timeline_card.dart';
import '../../widgets/common/section_header.dart';

/// 项目：基本信息 + 交付时间线（项目管理信息）
class ProjectTab extends StatelessWidget {
  final Project project;

  /// 点击「查看资料」回调（由页面层打开弹窗）
  final ValueChanged<PhaseItem>? onViewDoc;

  const ProjectTab({super.key, required this.project, this.onViewDoc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _InfoCard(project: project),
        const SizedBox(height: 16),
        TimelineCard(phases: project.phases, onViewDoc: onViewDoc),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Project project;

  const _InfoCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('客户', project.client),
      ('创建时间', project.created),
      ('最近更新', project.updated),
      ('当前阶段', project.currentPhase.label),
      ('状态', project.status),
      ('合同金额', '${project.contractAmount.toStringAsFixed(1)} 万元'),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(icon: Icons.info_outline, title: '项目信息'),
          const SizedBox(height: 12),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      r.$1,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      r.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
