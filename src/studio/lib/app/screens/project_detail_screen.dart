import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../project/models/project.dart';
import '../../asset/models/project_matrix.dart';
import '../../project/models/project_phase.dart';
import '../views/responsive.dart';
import '../views/sidebar.dart';
import '../views/doc_dialog.dart';
import '../views/detail_header.dart';
import '../../asset/screens/assets_tab.dart';
import '../../business/screens/business_tab.dart';
import '../../data/screens/data_tab.dart';
import './overview_tab.dart';
import '../../project/screens/project_tab.dart';

/// 详情页 5 个 Tab 的深链 slug（与页面分解原型 `?tab=` 口径一致）
const List<String> detailTabSlugs = [
  'overview',
  'data',
  'project',
  'business',
  'assets',
];

/// `?tab=` → Tab 下标；未知值回退总览
int detailTabIndex(String? slug) {
  final i = slug == null ? -1 : detailTabSlugs.indexOf(slug);
  return i < 0 ? 0 : i;
}

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  /// 深链进入时的初始 Tab（默认总览）
  final int initialTab;

  const ProjectDetailScreen({
    super.key,
    required this.project,
    this.initialTab = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Responsive(
          mobile: _buildDetail(context, compact: true),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Sidebar(),
              Expanded(child: _buildDetail(context, compact: false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, {required bool compact}) {
    final hPadding = compact ? 16.0 : 28.0;
    return DefaultTabController(
      key: ValueKey(initialTab),
      length: 5,
      initialIndex: initialTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          Padding(
            padding: EdgeInsets.fromLTRB(hPadding, 24, hPadding, 0),
            child: DetailHeader(
              project: project,
              compact: compact,
              onBack: () => _back(context),
            ),
          ),
          const SizedBox(height: 12),
          // Tab 栏
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDF4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                isScrollable: compact,
                onTap: (index) {
                  // 站内点 Tab 同步 URL（深链可分享）；无路由环境保持默认切换
                  GoRouter.maybeOf(context)?.go(
                    '/projects/${project.id}?tab=${detailTabSlugs[index]}',
                    extra: project,
                  );
                },
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
                  Tab(text: '总览'),
                  Tab(text: '数据'),
                  Tab(text: '项目'),
                  Tab(text: '商务'),
                  Tab(text: '资产'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tab 内容
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPadding, 0, hPadding, 0),
              child: TabBarView(
                children: [
                  OverviewTab(project: project),
                  DataTab(project: project),
                  ProjectTab(
                    project: project,
                    onViewDoc: (item) => _showDocDialog(context, item),
                  ),
                  BusinessTab(project: project),
                  AssetsTab(
                    project: project,
                    onCellTap: (cell) => _showAssetDialog(context, cell),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 头部 =====
  void _back(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router == null) {
      Navigator.of(context).pop();
    } else if (router.canPop()) {
      router.pop();
    } else {
      // 深链冷启动没有上一页，退回列表
      router.go('/');
    }
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
