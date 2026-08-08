import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/cards/blueprint_card.dart';

/// 数据：完整数据蓝图（处理流程 + 异常预案）
class DataTab extends StatelessWidget {
  final Project project;

  const DataTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [BlueprintCard(blueprint: project.blueprint)],
    );
  }
}
