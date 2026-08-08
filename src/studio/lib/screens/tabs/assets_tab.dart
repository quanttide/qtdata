import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/cards/matrix_card.dart';

/// 资产：交付资产地图（维度 × 阶段），单元格即资产条目
class AssetsTab extends StatelessWidget {
  final Project project;

  /// 点击资产条目（由页面层打开资料弹窗）
  final ValueChanged<MatrixCell>? onCellTap;

  const AssetsTab({super.key, required this.project, this.onCellTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        MatrixCard(matrix: project.matrix, onCellTap: onCellTap),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            '点击资产条目查看资料',
            style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
          ),
        ),
      ],
    );
  }
}
