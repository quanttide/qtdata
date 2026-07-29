import 'package:flutter/material.dart';
import '../models/project.dart';
import '../components/progress_bar_widget.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF94A3B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              '创建于 ${project.created}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${project.progressPercent}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Text(
                  '交付进度',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status bar
          _buildStatusBar(),
          const SizedBox(height: 16),
          // Progress bar section
          _buildProgressSection(),
          const SizedBox(height: 16),
          // Delivery targets
          _buildDeliveryTargets(),
          const SizedBox(height: 16),
          // Blueprint
          _buildBlueprint(),
          const SizedBox(height: 16),
          // Timeline
          _buildTimeline(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      children: [
        _buildStatusChip('状态', project.status,
            const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
        const SizedBox(width: 8),
        _buildStatusChip(
            '${project.currentPhase.label}阶段', '',
            const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      ],
    );
  }

  Widget _buildStatusChip(String label, String value, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value.isNotEmpty ? '$label: $value' : label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
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
          const Text(
            '交付进度',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          ProgressBarWidget(progress: project.progressPercent, height: 12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${project.elapsedDays}天 / ${project.totalDays}天',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                '${project.doneItems}/${project.totalItems} 交付物',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTargets() {
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
          _sectionHeader(Icons.flag_outlined, '交付目标',
              '每个阶段需要交付的内容'),
          const SizedBox(height: 12),
          ...project.deliveryTarget.map((dt) => _buildDeliveryCard(dt)),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(DeliveryTarget dt) {
    final grouped = <String, List<DeliveryItem>>{};
    for (final item in dt.items) {
      grouped.putIfAbsent(item.dim, () => []).add(item);
    }
    const dimOrder = ['项目', '数据', '商务'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chevron_right,
                  size: 14, color: Color(0xFF818CF8)),
              const SizedBox(width: 4),
              Text(
                '${dt.phase}阶段',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final dim in dimOrder) ...[
            if (grouped.containsKey(dim)) ...[
              Text(
                dim,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              for (final item in grouped[dim]!)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                  child: Row(
                    children: [
                      Icon(
                        item.status.isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 14,
                        color: item.status.isDone
                            ? const Color(0xFF10B981)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildBlueprint() {
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
          _sectionHeader(Icons.account_tree_outlined, '完整数据蓝图',
              '处理流程 + 异常预案'),
          const SizedBox(height: 16),
          // Steps
          const Text(
            '处理流程',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B82F6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...project.blueprint.steps.asMap().entries.map((e) =>
              _buildStep(e.key + 1, e.value.description)),
          if (project.blueprint.exceptions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '异常处理预案',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF59E0B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ...project.blueprint.exceptions.map(_buildException),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(int number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildException(BlueprintException e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              e.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: Text(
              e.strategy,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
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
          _sectionHeader(
              Icons.schedule_outlined, '交付时间线', '每个阶段的交付物'),
          const SizedBox(height: 16),
          ...project.phases.map((ph) => _buildTimelinePhase(ph)),
        ],
      ),
    );
  }

  Widget _buildTimelinePhase(ProjectPhaseDetail ph) {
    final Color dotColor;
    final Color borderColor;
    if (ph.status.isDone) {
      dotColor = const Color(0xFF10B981);
      borderColor = const Color(0xFF10B981);
    } else if (ph.status.isActive) {
      dotColor = const Color(0xFF3B82F6);
      borderColor = const Color(0xFF3B82F6);
    } else {
      dotColor = const Color(0xFF94A3B8);
      borderColor = const Color(0xFFE2E8F0);
    }

    final statusLabel = ph.status.isDone
        ? '已完成'
        : ph.status.isActive
            ? '进行中'
            : '待处理';

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ph.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          ...ph.items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined,
                        size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showDocSnackBar(item.name),
                      child: const Text(
                        '查看资料',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6366F1)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  void _showDocSnackBar(String name) {
    // Simulated doc viewer
  }
}
