import 'package:flutter/material.dart';

import '../models/project_matrix.dart';
import '../models/project_status.dart';
import 'matrix_cells.dart';
import 'section_header.dart';

/// 全流程进度总览（二维网格）
class MatrixCard extends StatelessWidget {
  final ProjectMatrix matrix;

  /// 点击资产单元格（资产页用于打开资料）
  final ValueChanged<MatrixCell>? onCellTap;

  const MatrixCard({super.key, required this.matrix, this.onCellTap});

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
          _MatrixTable(matrix: matrix, onCellTap: onCellTap),
          const SizedBox(height: 12),
          const _MatrixLegend(),
        ],
      ),
    );
  }
}

class _MatrixTable extends StatelessWidget {
  final ProjectMatrix matrix;
  final ValueChanged<MatrixCell>? onCellTap;

  const _MatrixTable({required this.matrix, this.onCellTap});

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
            const MatrixHeaderCell(text: '维度 \\ 阶段', bg: headerBg),
            ...matrix.columns.map(
              (c) => MatrixHeaderCell.phase(c, bg: headerBg),
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
                  return const MatrixDataCell.empty();
                }
                return MatrixDataCell.data(
                  cell.name,
                  cell.status,
                  onTap: onCellTap == null ? null : () => onCellTap!(cell),
                );
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
