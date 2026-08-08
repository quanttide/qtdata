import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/cards/project_card.dart';
import '../../widgets/common/status_badge.dart';

/// 仪表盘：项目摘要 + 交付物明细
class OverviewTab extends StatelessWidget {
  final Project project;

  const OverviewTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ProjectCard(project: project, onTap: () {}),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '交付物明细',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 12),
              ...project.deliverables.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          d.name,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      StatusBadge(status: d.status.label),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
