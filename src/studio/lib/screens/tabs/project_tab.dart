import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/common/section_header.dart';

/// 项目：基本信息 + 商务流程（调研 → 复盘）
class ProjectTab extends StatelessWidget {
  final Project project;

  const ProjectTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _InfoCard(project: project),
        const SizedBox(height: 16),
        _BusinessFlowCard(matrix: project.matrix),
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

/// 商务流程步骤条：取矩阵 project 行的 5 阶段状态
class _BusinessFlowCard extends StatelessWidget {
  final ProjectMatrix matrix;

  const _BusinessFlowCard({required this.matrix});

  @override
  Widget build(BuildContext context) {
    final steps = matrix.columns
        .map(
          (col) => (label: col.label, cell: matrix.cellAt('project', col.key)),
        )
        .toList();

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
          const SectionHeader(
            icon: Icons.flag_outlined,
            title: '商务流程',
            subtitle: '| 调研 → 复盘',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: _isStepDone(steps[i - 1].cell)
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                _StepDot(status: steps[i].cell?.status, label: steps[i].label),
              ],
            ],
          ),
        ],
      ),
    );
  }

  bool _isStepDone(MatrixCell? cell) => cell?.status == ItemStatus.done;
}

class _StepDot extends StatelessWidget {
  final ItemStatus? status;
  final String label;

  const _StepDot({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = status?.color ?? const Color(0xFFE2E8F0);
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: status == null ? const Color(0xFFE2E8F0) : color,
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
