import 'package:flutter/material.dart';

import '../models/project_matrix.dart';
import '../../app/models/project_status.dart';

class MatrixHeaderCell extends StatelessWidget {
  final String text;
  final Color bg;
  final String? statusLabel;
  final Color chipBg;
  final Color chipFg;

  const MatrixHeaderCell({
    super.key,
    required this.text,
    required this.bg,
    this.statusLabel,
    this.chipBg = const Color(0xFFF1F5F9),
    this.chipFg = const Color(0xFF94A3B8),
  });

  /// 阶段列表头：阶段名 + 状态标签
  factory MatrixHeaderCell.phase(MatrixColumn col, {required Color bg}) {
    return MatrixHeaderCell(
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

class MatrixDataCell extends StatelessWidget {
  final String name;
  final ItemStatus? status;
  final bool empty;
  final VoidCallback? onTap;

  const MatrixDataCell.data(this.name, this.status, {super.key, this.onTap})
    : empty = false;
  const MatrixDataCell.empty({super.key})
    : name = '—',
      status = null,
      empty = true,
      onTap = null;

  @override
  Widget build(BuildContext context) {
    final borderColor = status?.color ?? Colors.transparent;
    final cell = Container(
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
    return onTap == null ? cell : GestureDetector(onTap: onTap, child: cell);
  }
}
