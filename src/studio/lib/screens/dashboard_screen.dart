import 'package:flutter/material.dart';
import '../models/project.dart';
import '../mock_data.dart';
import '../components/project_card.dart';
import 'project_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'all';
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final now = DateTime.now();
    _currentTime =
        '${now.year}-${_pad(now.month)}-${_pad(now.day)} ${_pad(now.hour)}:${_pad(now.minute)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  List<Project> get _filteredProjects {
    final all = mockProjects.values.toList();
    if (_filter == 'all') return all;
    if (_filter == 'active') {
      return all.where((p) => p.progressPercent > 0 && p.progressPercent < 100).toList();
    }
    if (_filter == 'done') {
      return all.where((p) => p.progressPercent >= 100).toList();
    }
    if (_filter == 'pending') {
      return all.where((p) => p.progressPercent == 0).toList();
    }
    return all;
  }

  int get _allCount => mockProjects.length;
  int get _activeCount =>
      mockProjects.values.where((p) => p.progressPercent > 0 && p.progressPercent < 100).length;
  int get _doneCount =>
      mockProjects.values.where((p) => p.progressPercent >= 100).length;
  int get _pendingCount =>
      mockProjects.values.where((p) => p.progressPercent == 0).length;

  void _openDetail(Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(project: project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '仪表盘',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '交付进度总览 · 实时更新',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _currentTime,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filter pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterPill('全部', 'all', _allCount),
                    const SizedBox(width: 8),
                    _buildFilterPill('进行中', 'active', _activeCount,
                        color: const Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    _buildFilterPill('已完成', 'done', _doneCount,
                        color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    _buildFilterPill('待启动', 'pending', _pendingCount,
                        color: const Color(0xFF94A3B8)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Project list
              Expanded(
                child: _filteredProjects.isEmpty
                    ? const Center(
                        child: Text(
                          '暂无匹配的项目',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredProjects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final project = _filteredProjects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () => _openDetail(project),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, String value, int count, {Color? color}) {
    final isActive = _filter == value;
    final fgColor = isActive
        ? const Color(0xFF4F46E5)
        : (color ?? const Color(0xFF1E293B));
    final bgColor = isActive
        ? const Color(0xFFE0E7FF)
        : const Color(0xFFFFFFFF);

    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: const Color(0xFF4F46E5), width: 2)
              : Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: fgColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
