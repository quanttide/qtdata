import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/project.dart';
import '../models/seed_loader.dart';
import '../views/project_filters.dart';
import '../views/project_list.dart';
import '../../app/views/responsive.dart';
import '../../app/views/sidebar.dart';
import '../../app/screens/project_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'all';
  List<Project>? _projects;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    // 已加载过就同步取，避免悬挂的异步订阅（测试环境坑，见 seed_loader 注释）
    final ready = seedProjectsIfLoaded();
    if (ready != null) {
      _projects = ready;
    } else {
      _loadProjects();
    }
  }

  Future<void> _loadProjects() async {
    try {
      final projects = await loadSeedProjects();
      if (!mounted) return;
      setState(() => _projects = projects);
    } catch (e) {
      debugPrint('种子数据加载失败: $e');
      if (!mounted) return;
      setState(() => _loadFailed = true);
    }
  }

  List<Project> get _all => _projects ?? const [];

  List<Project> get _filteredProjects {
    final all = _all;
    if (_filter == 'all') return all;
    if (_filter == 'active') {
      return all.where((p) => p.status == '进行中').toList();
    }
    if (_filter == 'done') {
      return all.where((p) => p.status == '已完成').toList();
    }
    if (_filter == 'pending') {
      return all.where((p) => p.status == '待启动').toList();
    }
    return all;
  }

  int get _allCount => _all.length;
  int get _activeCount => _all.where((p) => p.status == '进行中').length;
  int get _doneCount => _all.where((p) => p.status == '已完成').length;
  int get _pendingCount => _all.where((p) => p.status == '待启动').length;

  void _openDetail(Project project) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      // 站内跳转带 extra：详情页免二次异步加载，URL 同步可分享/深链
      router.go('/projects/${project.id}', extra: project);
      return;
    }
    // 无路由环境（部件单测直挂 MaterialApp）保留原有 push 行为
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectDetailScreen(project: project),
      ),
    );
  }

  void _setFilter(String f) => setState(() => _filter = f);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Responsive(
          mobile: _buildBody(context, compact: true),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Sidebar(),
              Expanded(child: _buildBody(context, compact: false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, {required bool compact}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 28,
        compact ? 16 : 28,
        compact ? 16 : 28,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          const Text(
            '我的项目',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '当前所有数据项目的进度总览',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          // 统计卡片
          _buildStatCards(),
          const SizedBox(height: 16),
          // 筛选按钮组 + 计数
          Row(
            children: [
              ProjectFilterGroup(filter: _filter, onSelect: _setFilter),
              const SizedBox(width: 12),
              Text(
                '${_filteredProjects.length} 个项目',
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 项目列表
          Expanded(
            child: ProjectList(
              projects: _filteredProjects,
              loading: _projects == null,
              loadFailed: _loadFailed,
              onOpen: _openDetail,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return StatCards(
      cards: [
        StatCardData(
          label: '全部项目',
          count: _allCount,
          numberColor: const Color(0xFF4F46E5),
          filter: 'all',
        ),
        StatCardData(
          label: '进行中',
          count: _activeCount,
          numberColor: const Color(0xFFF59E0B),
          filter: 'active',
        ),
        StatCardData(
          label: '已完成',
          count: _doneCount,
          numberColor: const Color(0xFF10B981),
          filter: 'done',
        ),
        StatCardData(
          label: '待启动',
          count: _pendingCount,
          numberColor: const Color(0xFF94A3B8),
          filter: 'pending',
        ),
      ],
      activeFilter: _filter,
      onSelect: _setFilter,
    );
  }
}
