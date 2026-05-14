import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanttide_data/quanttide_data.dart';
import 'pipeline_view.dart';

class DataScreen extends StatelessWidget {
  final Pipeline pipeline;
  final PipelineBloc? bloc;

  const DataScreen({super.key, required this.pipeline, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc ?? PipelineBloc()..add(LoadPipeline(pipeline)),
      child: const PipelineView(),
    );
  }
}
