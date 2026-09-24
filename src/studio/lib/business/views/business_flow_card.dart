import 'package:flutter/material.dart';

import '../../asset/models/project_matrix.dart';
import '../../app/models/project_status.dart';
import '../../app/views/section_header.dart';

/// 商务管理阶段：调研 → 谈判 → 实施 → 验收 → 复盘（矩阵列状态）
class BusinessFlowCard extends StatelessWidget {
  final ProjectMatrix matrix;

  const BusinessFlowCard({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
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
            title: '商务管理阶段',
            subtitle: '| 调研 → 复盘',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (var i = 0; i < matrix.columns.length; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: matrix.columns[i - 1].status == ItemStatus.done
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                _StepDot(
                  status: matrix.columns[i].status,
                  label: matrix.columns[i].label,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final ItemStatus status;
  final String label;

  const _StepDot({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
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
