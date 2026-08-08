import 'package:flutter/material.dart';
import '../models/project.dart';
import 'progress_bar_widget.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  Color get _statusBg {
    if (project.status == '已完成') return const Color(0xFFD1FAE5);
    if (project.status == '进行中') return const Color(0xFFDBEAFE);
    return const Color(0xFFFEF3C7);
  }

  Color get _statusFg {
    if (project.status == '已完成') return const Color(0xFF065F46);
    if (project.status == '进行中') return const Color(0xFF1D4ED8);
    return const Color(0xFF92400E);
  }

  (Color, Color) get _phaseColors {
    switch (project.currentPhase) {
      case ProjectPhase.research:
        return (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8));
      case ProjectPhase.negotiate:
        return (const Color(0xFFFEF3C7), const Color(0xFF92400E));
      case ProjectPhase.implement:
        return (const Color(0xFFD1FAE5), const Color(0xFF065F46));
      case ProjectPhase.accept:
        return (const Color(0xFFEDE9FE), const Color(0xFF5B21B6));
      case ProjectPhase.review:
        return (const Color(0xFFFCE7F3), const Color(0xFF9D174D));
    }
  }

  @override
  Widget build(BuildContext context) {
    final phaseColors = _phaseColors;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 名称 + 状态徽章 + 阶段标签 + 更新时间
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            project.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          _chip(project.status, _statusBg, _statusFg),
                          _chip(
                            '${project.currentPhase.label}阶段',
                            phaseColors.$1,
                            phaseColors.$2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '更新于 ${project.updated}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 交付物仪表
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _dashItem(
                      '${project.doneItems}',
                      '已完成',
                      border: const Color(0xFFA7F3D0),
                      bg: const Color(0xFFF0FDF4),
                      fg: const Color(0xFF065F46),
                      numColor: const Color(0xFF10B981),
                    ),
                    _dashItem(
                      '${project.activeItems}',
                      '进行中',
                      border: const Color(0xFF93C5FD),
                      bg: const Color(0xFFEFF6FF),
                      fg: const Color(0xFF1D4ED8),
                      numColor: const Color(0xFF3B82F6),
                    ),
                    _dashItem(
                      '${project.todoItems}',
                      '待启动',
                      border: const Color(0xFFE2E8F0),
                      bg: const Color(0xFFF8FAFC),
                      fg: const Color(0xFF64748B),
                      numColor: const Color(0xFF94A3B8),
                    ),
                    Text(
                      '共 ${project.totalItems} 项',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 完成度进度条 + 确认收入
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '交付完成度',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                '${project.progressPercent}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ProgressBarWidget(
                            progress: project.progressPercent,
                            height: 5,
                            animated: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 💰 确认收入
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: '💰 '),
                            TextSpan(
                              text: project.confirmedIncome.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' / ${project.contractAmount.toStringAsFixed(1)} 万元',
                              style: const TextStyle(color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }

  Widget _dashItem(
    String num,
    String label, {
    required Color border,
    required Color bg,
    required Color fg,
    required Color numColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 2, 8, 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            num,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: numColor,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
