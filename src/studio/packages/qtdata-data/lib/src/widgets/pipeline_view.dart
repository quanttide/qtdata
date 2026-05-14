import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanttide_data/quanttide_data.dart';
import 'task_card.dart';

class PipelineView extends StatelessWidget {
  const PipelineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PipelineBloc, PipelineState>(
      builder: (context, state) => switch (state) {
        PipelineInitial() => const SizedBox.shrink(),
        PipelineLoading() => const Center(child: CircularProgressIndicator()),
        PipelineLoaded(:final pipeline) => _buildFlow(pipeline),
        PipelineLoadFailed(:final message) => Center(child: Text(message)),
      },
    );
  }

  Widget _buildFlow(Pipeline pipeline) {
    if (pipeline.tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < pipeline.tasks.length; i++) ...[
            TaskCard(task: pipeline.tasks[i]),
            if (i < pipeline.tasks.length - 1) const _Arrow(),
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
