import 'package:flutter/material.dart';
import '../models/project.dart';
import 'section_header.dart';

/// 全流程进度总览（二维网格）
class MatrixCard extends StatelessWidget {
  final ProjectMatrix matrix;

  const MatrixCard({super.key, required this.matrix});

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
            icon: Icons.table_chart_outlined,
            title: '全流程进度总览',
          ),
          const SizedBox(height: 16),
          _MatrixTable(matrix: matrix),
          const SizedBox(height: 12),
          const _MatrixLegend(),
        ],
      ),
    );
  }
}

class _MatrixTable extends StatelessWidget {
  final ProjectMatrix matrix;

  const _MatrixTable({required this.matrix});

  @override
  Widget build(BuildContext context) {
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
            ...matrix.columns.map(
              (c) => _MatrixHeaderCell.phase(c, bg: headerBg),
            ),
          ],
        ),
        // 数据行
        ...matrix.rows.map(
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
              ...matrix.columns.map((col) {
                final cell = matrix.cellAt(row.key, col.key);
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
}

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
    return _MatrixHeaderCell(
      text: col.label,
      bg: bg,
      statusLabel: col.status.label,
      chipBg: col.status.badgeBg,
      chipFg: col.status.badgeFg,
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
    final borderColor = status?.color ?? Colors.transparent;
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
                        color: status!.color,
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

class _MatrixLegend extends StatelessWidget {
  const _MatrixLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 6,
        children: [
          _LegendDot(color: ItemStatus.done.color, label: '已完成'),
          _LegendDot(color: ItemStatus.active.color, label: '进行中'),
          _LegendDot(color: ItemStatus.todo.color, label: '待启动'),
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
