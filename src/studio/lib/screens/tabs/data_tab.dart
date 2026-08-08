import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/cards/blueprint_card.dart';
import '../../widgets/cards/timeline_card.dart';

/// 数据：完整数据蓝图（流程 + 异常预案）+ 交付时间线
class DataTab extends StatelessWidget {
  final Project project;

  /// 点击「查看资料」回调（由页面层打开弹窗）
  final ValueChanged<PhaseItem>? onViewDoc;

  const DataTab({super.key, required this.project, this.onViewDoc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        BlueprintCard(blueprint: project.blueprint),
        const SizedBox(height: 16),
        TimelineCard(phases: project.phases, onViewDoc: onViewDoc),
      ],
    );
  }
}
