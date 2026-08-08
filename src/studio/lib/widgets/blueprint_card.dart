import 'package:flutter/material.dart';
import '../models/project.dart';
import 'section_header.dart';

/// 完整数据蓝图（处理流程 + 异常预案）
class BlueprintCard extends StatelessWidget {
  final Blueprint blueprint;

  const BlueprintCard({super.key, required this.blueprint});

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
            icon: Icons.account_tree_outlined,
            title: '完整数据蓝图',
            subtitle: '| 处理流程 + 异常预案',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BlueprintLabel('处理流程', color: Color(0xFF3B82F6)),
                const SizedBox(height: 8),
                ...blueprint.steps.asMap().entries.map(
                  (e) => _BlueprintStepRow(e.key + 1, e.value.description),
                ),
                if (blueprint.exceptions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const _BlueprintLabel('异常处理预案', color: Color(0xFFF59E0B)),
                  const SizedBox(height: 8),
                  ...blueprint.exceptions.map(_BlueprintExceptionRow.new),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlueprintLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _BlueprintLabel(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _BlueprintStepRow extends StatelessWidget {
  final int number;
  final String description;

  const _BlueprintStepRow(this.number, this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF4F46E5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF334155),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlueprintExceptionRow extends StatelessWidget {
  final BlueprintException exception;

  const _BlueprintExceptionRow(this.exception);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF8FAFC))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              exception.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              exception.strategy,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }
}
