import 'package:flutter_bloc/flutter_bloc.dart';
import '../pipeline.dart';

abstract class PipelineEvent {}

class LoadPipeline extends PipelineEvent {
  final Pipeline pipeline;

  LoadPipeline(this.pipeline);
}

abstract class PipelineState {}

class PipelineInitial extends PipelineState {}

class PipelineLoaded extends PipelineState {
  final Pipeline pipeline;

  PipelineLoaded(this.pipeline);
}

class PipelineBloc extends Bloc<PipelineEvent, PipelineState> {
  PipelineBloc() : super(PipelineInitial()) {
    on<LoadPipeline>(_onLoadPipeline);
  }

  void _onLoadPipeline(LoadPipeline event, Emitter<PipelineState> emit) {
    emit(PipelineLoaded(event.pipeline));
  }
}
