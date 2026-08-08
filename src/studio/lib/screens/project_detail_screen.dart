import 'package:flutter/material.dart';

import '../models/project.dart';
import '../widgets/common/phase_tag.dart';
import '../widgets/common/sidebar.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/common/toast.dart';
import '../widgets/dialogs/doc_dialog.dart';
import 'tabs/assets_tab.dart';
import 'tabs/business_tab.dart';
import 'tabs/data_tab.dart';
import 'tabs/overview_tab.dart';
import 'tabs/project_tab.dart';

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
              child: DefaultTabController(
                length: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 头部
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                      child: _buildHeader(context),
                    ),
                    const SizedBox(height: 12),
                    // Tab 栏
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EDF4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          labelColor: const Color(0xFF1E293B),
                          unselectedLabelColor: const Color(0xFF64748B),
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(text: '仪表盘'),
                            Tab(text: '项目'),
                            Tab(text: '数据'),
                            Tab(text: '资产'),
                            Tab(text: '商务'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tab 内容
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                        child: TabBarView(
                          children: [
                            OverviewTab(project: project),
                            ProjectTab(project: project),
                            DataTab(
                              project: project,
                              onViewDoc: (item) =>
                                  _showDocDialog(context, item),
                            ),
                            AssetsTab(
                              project: project,
                              onCellTap: (cell) =>
                                  _showAssetDialog(context, cell),
                            ),
                            BusinessTab(project: project),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

  Future<void> _showAssetDialog(BuildContext context, MatrixCell cell) =>
      showDocDialog(
        context,
        projectName: project.name,
        item: PhaseItem(name: cell.name, desc: '', hasDoc: true, type: '资产'),
      );
}
