import 'package:flutter/material.dart';

import '../../project/models/project.dart';
import './phase_tag.dart';
import './status_badge.dart';
import './toast.dart';

/// 详情页头部：返回、标题（状态徽章 + 阶段标签）、客户信息与导出按钮。
///
/// 从 `project_detail_screen` 拆出（单文件 ≤250 行约定）。
class DetailHeader extends StatelessWidget {
  final Project project;
  final bool compact;
  final VoidCallback onBack;

  const DetailHeader({
    super.key,
    required this.project,
    required this.compact,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
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
        // 导出按钮（移动端仅图标）
        InkWell(
          onTap: () => showAppToast(context, '📄 报告已导出'),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: compact
                ? const EdgeInsets.all(8)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: compact
                ? const Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 14,
                    color: Colors.white,
                  )
                : const Row(
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
}
