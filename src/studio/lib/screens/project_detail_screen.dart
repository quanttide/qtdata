import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(fontSize: 13)),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
        ),
      );
  }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头部
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                    child: _buildHeader(context),
                  ),
                  const SizedBox(height: 16),
                  // 内容区
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                      children: [
                        _buildMatrixCard(context),
                        const SizedBox(height: 16),
                        _buildBlueprintCard(),
                        const SizedBox(height: 16),
                        _buildTimelineCard(context),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            '点击「查看资料」获取交付物文件',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.space_dashboard_outlined,
              size: 20,
              color: Color(0xFF4F46E5),
            ),
          ),
          const Spacer(),
          const Icon(Icons.help_outline, size: 20, color: Color(0xFF94A3B8)),
          const SizedBox(height: 20),
        ],
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
                  // 状态徽章（原型固定蓝色）
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project.status,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                  _phaseTag(),
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
          onTap: () => _showToast(context, '📄 报告已导出'),
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

  Widget _phaseTag() {
    final (bg, fg) = switch (project.currentPhase) {
      ProjectPhase.research => (
        const Color(0xFFDBEAFE),
        const Color(0xFF1D4ED8),
      ),
      ProjectPhase.negotiate => (
        const Color(0xFFFEF3C7),
        const Color(0xFF92400E),
      ),
      ProjectPhase.implement => (
        const Color(0xFFD1FAE5),
        const Color(0xFF065F46),
      ),
      ProjectPhase.accept => (const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
      ProjectPhase.review => (const Color(0xFFFCE7F3), const Color(0xFF9D174D)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        project.currentPhase.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }

  // ===== 区块卡片头 =====
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
        if (subtitle.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ],
    );
  }

  // ===== 全流程进度总览（二维网格） =====
  Widget _buildMatrixCard(BuildContext context) {
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
          _sectionHeader(Icons.table_chart_outlined, '全流程进度总览', ''),
          const SizedBox(height: 16),
          _buildMatrixTable(),
          const SizedBox(height: 12),
          _buildMatrixLegend(),
        ],
      ),
    );
  }

  Widget _buildMatrixTable() {
    const headerBg = Color(0xFFF8FAFC);
    const cellBorder = Color(0xFFE2E8F0);

    final table = Table(
      border: TableBorder.all(color: cellBorder, width: 1),
      columnWidths: {
        0: const FixedColumnWidth(72),
        1: const FixedColumnWidth(96),
        2: const FixedColumnWidth(96),
        3: const FixedColumnWidth(96),
        4: const FixedColumnWidth(96),
        5: const FixedColumnWidth(96),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // 表头：角落 + 阶段列
        TableRow(
          decoration: const BoxDecoration(color: headerBg),
          children: [
            const _MatrixHeaderCell(text: '维度 \\ 阶段', bg: headerBg),
            ...project.matrix.columns.map(
              (c) => _MatrixHeaderCell.phase(c, bg: headerBg),
            ),
          ],
        ),
        // 数据行
        ...project.matrix.rows.map(
          (row) => TableRow(
            children: [
              // 行标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFCFF),
                  border: Border(
                    top: BorderSide(color: cellBorder, width: 1),
                    bottom: BorderSide(color: cellBorder, width: 1),
                  ),
                ),
                child: Text(
                  row.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              // 单元格
              ...project.matrix.columns.map((col) {
                final cell = project.matrix.cellAt(row.key, col.key);
                if (cell == null) {
                  return const _MatrixCell.empty();
                }
                return _MatrixCell.data(cell.name, cell.status);
              }),
            ],
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: table,
    );
  }

  Widget _buildMatrixLegend() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 6,
        children: const [
          _LegendDot(color: Color(0xFF10B981), label: '已完成'),
          _LegendDot(color: Color(0xFF3B82F6), label: '进行中'),
          _LegendDot(color: Color(0xFF94A3B8), label: '待启动'),
        ],
      ),
    );
  }

  // ===== 完整数据蓝图 =====
  Widget _buildBlueprintCard() {
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
            Icons.account_tree_outlined,
            '完整数据蓝图',
            '| 处理流程 + 异常预案',
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
                ...project.blueprint.steps.asMap().entries.map(
                  (e) => _buildStep(e.key + 1, e.value.description),
                ),
                if (project.blueprint.exceptions.isNotEmpty) ...[
                  const SizedBox(height: 8),
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
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String description) {
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

  Widget _buildException(BlueprintException e) {
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
              e.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              e.strategy,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  // ===== 交付时间线 =====
  Widget _buildTimelineCard(BuildContext context) {
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
          _sectionHeader(Icons.schedule_outlined, '交付时间线', '| 每个阶段的交付物'),
          const SizedBox(height: 16),
          ...project.phases.map((ph) => _buildTimelinePhase(ph, context)),
        ],
      ),
    );
  }

  Widget _buildTimelinePhase(ProjectPhaseDetail ph, BuildContext context) {
    final (dotColor, glow) = switch (ph.status) {
      ItemStatus.done => (const Color(0xFF10B981), false),
      ItemStatus.active => (const Color(0xFF4F46E5), true),
      ItemStatus.todo => (const Color(0xFFE2E8F0), false),
    };
    final borderColor = switch (ph.status) {
      ItemStatus.done => const Color(0xFF10B981),
      ItemStatus.active => const Color(0xFF4F46E5),
      ItemStatus.todo => const Color(0xFFD1D5DB),
    };
    final (chipBg, chipFg) = switch (ph.status) {
      ItemStatus.done => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      ItemStatus.active => (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      ItemStatus.todo => (const Color(0xFFF1F5F9), const Color(0xFF94A3B8)),
    };

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
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ph.status == ItemStatus.todo
                        ? const Color(0xFFD1D5DB)
                        : dotColor,
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
                ph.name,
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
                  color: chipBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ph.status.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: chipFg,
                  ),
                ),
              ),
              if (ph.items.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  '${ph.items.length} 项',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ],
          ),
          ...ph.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 20, top: 6),
              child: _buildDeliverable(item, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverable(PhaseItem item, BuildContext context) {
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
          if (item.hasDoc)
            InkWell(
              onTap: () => _showDocDialog(context, item),
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

  // ===== 资料弹窗 =====
  List<({String name, String size})> _docFiles(String name) {
    if (name.contains('Assignor')) {
      return [
        (name: 'TMA_assignor_matched.csv', size: '12.7 MB'),
        (name: 'Assignor_AI审核摘要.pdf', size: '0.8 MB'),
        (name: 'assignor_threshold_log.xlsx', size: '0.3 MB'),
      ];
    }
    if (name.contains('Assignee')) {
      return [
        (name: 'TMA_assignee_matched.csv', size: '8.3 MB'),
        (name: 'assignee_code_package.zip', size: '45.2 MB'),
        (name: 'assignee_progress_log.docx', size: '0.2 MB'),
      ];
    }
    if (name.contains('Owner')) {
      return [
        (name: 'TMC_owner_matched.csv', size: '6.1 MB'),
        (name: 'owner_matching_spec.pdf', size: '0.5 MB'),
      ];
    }
    if (name.contains('标准化')) {
      return [
        (name: 'name_standardization_rules.xlsx', size: '0.4 MB'),
        (name: 'standardized_names_sample.csv', size: '2.1 MB'),
      ];
    }
    if (name.contains('合同')) {
      return [
        (name: '内部客户_合同扫描件.pdf', size: '1.8 MB'),
        (name: '合同签署记录.jpg', size: '0.3 MB'),
      ];
    }
    return [
      (name: '$name.pdf', size: '1.2 MB'),
      (name: '${name}_data.csv', size: '0.8 MB'),
    ];
  }

  Future<void> _showDocDialog(BuildContext context, PhaseItem item) async {
    final files = _docFiles(item.name);
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${project.name} · ${item.type.isEmpty ? '资料' : item.type}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '以下资料可供下载：',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 8),
              ...files.map(
                (f) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 14,
                        color: Color(0xFF4F46E5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      Text(
                        f.size,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _showToast(context, '📥 下载 ${f.name}');
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            '下载',
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
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: const Text(
                  '📊 Assignor 跑数摘要：58,797 条进入 AI 审核 | 5,067 条自动通过（8.6%）| 91.4% 判定无匹配',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== 二维网格内部组件 =====

class _MatrixHeaderCell extends StatelessWidget {
  final String text;
  final Color bg;
  final String? statusLabel;
  final Color chipBg;
  final Color chipFg;

  const _MatrixHeaderCell({
    required this.text,
    required this.bg,
    this.statusLabel,
    this.chipBg = const Color(0xFFF1F5F9),
    this.chipFg = const Color(0xFF94A3B8),
  });

  /// 阶段列表头：阶段名 + 状态标签
  factory _MatrixHeaderCell.phase(MatrixColumn col, {required Color bg}) {
    final (chipBg, chipFg) = switch (col.status) {
      ItemStatus.done => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      ItemStatus.active => (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      ItemStatus.todo => (const Color(0xFFF1F5F9), const Color(0xFF94A3B8)),
    };
    return _MatrixHeaderCell(
      text: col.label,
      bg: bg,
      statusLabel: col.status.label,
      chipBg: chipBg,
      chipFg: chipFg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: bg),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          if (statusLabel != null) ...[
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                statusLabel!,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: chipFg,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MatrixCell extends StatelessWidget {
  final String name;
  final ItemStatus? status;
  final bool empty;

  const _MatrixCell.data(this.name, this.status) : empty = false;
  const _MatrixCell.empty() : name = '—', status = null, empty = true;

  @override
  Widget build(BuildContext context) {
    final borderColor = switch (status) {
      ItemStatus.done => const Color(0xFF10B981),
      ItemStatus.active => const Color(0xFF3B82F6),
      ItemStatus.todo => const Color(0xFFD1D5DB),
      null => Colors.transparent,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: empty
          ? const Center(
              child: Text(
                '—',
                style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: switch (status) {
                          ItemStatus.done => const Color(0xFF10B981),
                          ItemStatus.active => const Color(0xFF3B82F6),
                          ItemStatus.todo => const Color(0xFF94A3B8),
                          null => Colors.transparent,
                        },
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      status!.label,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}
