import 'package:bloc/bloc.dart';
import 'package:quanttide_data/quanttide_data.dart';

abstract class PipelineEvent {}

class LoadPipeline extends PipelineEvent {
  final Pipeline pipeline;

  LoadPipeline(this.pipeline);
}

sealed class PipelineState {}

class PipelineInitial extends PipelineState {}

class PipelineLoading extends PipelineState {}

class PipelineLoaded extends PipelineState {
  final Pipeline pipeline;

  PipelineLoaded(this.pipeline);
}

class PipelineError extends PipelineState {
  final String message;

  PipelineError(this.message);
}

class PipelineBloc extends Bloc<PipelineEvent, PipelineState> {
  PipelineBloc() : super(PipelineInitial()) {
    on<LoadPipeline>(_onLoadPipeline);
  }

  void _onLoadPipeline(LoadPipeline event, Emitter<PipelineState> emit) {
    emit(PipelineLoading());
    emit(PipelineLoaded(event.pipeline));
  }
}
