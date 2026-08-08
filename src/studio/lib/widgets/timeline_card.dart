import 'package:flutter/material.dart';
import '../models/project.dart';
import 'section_header.dart';

/// 交付时间线（每个阶段的交付物）
class TimelineCard extends StatelessWidget {
  final List<ProjectPhaseDetail> phases;

  /// 点击「查看资料」回调（由页面层打开弹窗）
  final ValueChanged<PhaseItem>? onViewDoc;

  const TimelineCard({super.key, required this.phases, this.onViewDoc});

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
            icon: Icons.schedule_outlined,
            title: '交付时间线',
            subtitle: '| 每个阶段的交付物',
          ),
          const SizedBox(height: 16),
          ...phases.map((ph) => _TimelinePhase(ph, onViewDoc: onViewDoc)),
        ],
      ),
    );
  }
}

class _TimelinePhase extends StatelessWidget {
  final ProjectPhaseDetail phase;
  final ValueChanged<PhaseItem>? onViewDoc;

  const _TimelinePhase(this.phase, {this.onViewDoc});

  @override
  Widget build(BuildContext context) {
    final status = phase.status;
    final borderColor = status.color;
    final glow = status == ItemStatus.active;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: status == ItemStatus.todo
                        ? const Color(0xFFD1D5DB)
                        : status.color,
                  ),
                  boxShadow: glow
                      ? const [
                          BoxShadow(
                            color: Color(0x334F46E5),
                            blurRadius: 0,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                phase.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status.badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: status.badgeFg,
                  ),
                ),
              ),
              if (phase.items.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  '${phase.items.length} 项',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ],
          ),
          ...phase.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 20, top: 6),
              child: _DeliverableRow(item, onViewDoc: onViewDoc),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverableRow extends StatelessWidget {
  final PhaseItem item;
  final ValueChanged<PhaseItem>? onViewDoc;

  const _DeliverableRow(this.item, {this.onViewDoc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            size: 14,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: item.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: ' — '),
                  TextSpan(text: item.desc),
                ],
              ),
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
            ),
          ),
          if (item.hasDoc && onViewDoc != null)
            InkWell(
              onTap: () => onViewDoc!(item),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  '查看资料',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
