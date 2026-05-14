import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pipeline.dart';
import '../state/pipeline_bloc.dart';
import 'task_card.dart';

class PipelineScreen extends StatelessWidget {
  final Pipeline pipeline;

  const PipelineScreen({super.key, required this.pipeline});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PipelineBloc()..add(LoadPipeline(pipeline)),
      child: const _PipelineView(),
    );
  }
}

class _PipelineView extends StatelessWidget {
  const _PipelineView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PipelineBloc, PipelineState>(
      builder: (context, state) {
        if (state is PipelineLoaded) {
          return _buildFlow(state.pipeline);
        }
        return const SizedBox.shrink();
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
