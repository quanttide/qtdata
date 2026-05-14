import 'package:flutter/material.dart';
import '../process_flow.dart';
import 'stage_card.dart';

class ProcessFlowScreen extends StatelessWidget {
  final ProcessFlow flow;

  const ProcessFlowScreen({super.key, required this.flow});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < flow.stages.length; i++) ...[
            StageCard(stage: flow.stages[i]),
            if (i < flow.stages.length - 1) const _Arrow(),
          ],
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade300,
      ),
    );
  }
}
