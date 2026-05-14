import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanttide_data/quanttide_data.dart';
import '../components/dataset_panel.dart';
import '../components/pipeline_panel.dart';

class DataScreen extends StatelessWidget {
  final String pipelineId;
  final PipelineRepository repository;
  final List<Dataset> datasets;
  final PipelineBloc? bloc;

  const DataScreen({
    super.key,
    required this.pipelineId,
    required this.repository,
    this.datasets = const [],
    this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          bloc ??
          PipelineBloc(repository: repository)
            ..add(LoadPipeline(pipelineId)),
      child: Column(
        children: [
          const PipelinePanel(),
          DatasetPanel(datasets: datasets),
        ],
      ),
    );
  }
}
