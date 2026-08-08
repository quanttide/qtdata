import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/project.dart';
import '../components/project_card.dart';
import 'project_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _seedAsset = 'assets/data/seed_projects.json';

  String _filter = 'all';
  List<Project>? _projects;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final raw = await rootBundle.loadString(_seedAsset);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final projects = (decoded['projects'] as List<dynamic>)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList();
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project)),
    );
  }

  void _setFilter(String f) => setState(() => _filter = f);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
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
                        _buildFilterGroup(),
                        const SizedBox(width: 12),
                        Text(
                          '${_filteredProjects.length} 个项目',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 项目列表
                    Expanded(child: _buildProjectList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 项目列表 =====
  Widget _buildProjectList() {
    if (_loadFailed) {
      return const Center(
        child: Text('种子数据加载失败', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }
    if (_projects == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_filteredProjects.isEmpty) {
      return const Center(
        child: Text('暂无匹配的项目', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }
    return ListView.separated(
      itemCount: _filteredProjects.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final project = _filteredProjects[index];
        return ProjectCard(project: project, onTap: () => _openDetail(project));
      },
    );
  }

  // ===== 侧边栏 =====
  Widget _buildSidebar() {
    return Container(
      width: 80,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '量',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 16),
          _sidebarIcon(Icons.space_dashboard_outlined, active: true),
          const Spacer(),
          _sidebarIcon(Icons.help_outline),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, {bool active = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE0E7FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 20,
        color: active ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
      ),
    );
  }

  // ===== 统计卡片 =====
  Widget _buildStatCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 4 : 2;
        final cards = [
          _StatCardData(
            label: '全部项目',
            count: _allCount,
            numberColor: const Color(0xFF4F46E5),
            filter: 'all',
          ),
          _StatCardData(
            label: '进行中',
            count: _activeCount,
            numberColor: const Color(0xFFF59E0B),
            filter: 'active',
          ),
          _StatCardData(
            label: '已完成',
            count: _doneCount,
            numberColor: const Color(0xFF10B981),
            filter: 'done',
          ),
          _StatCardData(
            label: '待启动',
            count: _pendingCount,
            numberColor: const Color(0xFF94A3B8),
            filter: 'pending',
          ),
        ];
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: cards
              .map(
                (c) => _statCard(
                  c,
                  active: _filter == c.filter,
                  onTap: () => _setFilter(c.filter),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _statCard(
    _StatCardData data, {
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
          ),
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x1A4F46E5),
                    blurRadius: 0,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${data.count}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: data.numberColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data.label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 筛选按钮组 =====
  Widget _buildFilterGroup() {
    const filters = [
      ('全部', 'all'),
      ('进行中', 'active'),
      ('已完成', 'done'),
      ('待启动', 'pending'),
    ];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filters.map((f) {
          final (label, value) = f;
          final isActive = _filter == value;
          return InkWell(
            onTap: () => _setFilter(value),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isActive
                    ? const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatCardData {
  final String label;
  final int count;
  final Color numberColor;
  final String filter;

  const _StatCardData({
    required this.label,
    required this.count,
    required this.numberColor,
    required this.filter,
  });
}
