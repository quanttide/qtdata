import 'package:flutter_bloc/flutter_bloc.dart';
import '../pipeline.dart';
import '../task.dart';
import '../task_status.dart';

abstract class PipelineEvent {}

class LoadPipeline extends PipelineEvent {
  final Pipeline pipeline;

  LoadPipeline(this.pipeline);
}

class UpdateTaskStatus extends PipelineEvent {
  final String taskId;
  final TaskStatus status;

  UpdateTaskStatus(this.taskId, this.status);
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
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
  }

  void _onLoadPipeline(LoadPipeline event, Emitter<PipelineState> emit) {
    emit(PipelineLoaded(event.pipeline));
  }

  void _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<PipelineState> emit,
  ) {
    if (state is PipelineLoaded) {
      final current = (state as PipelineLoaded).pipeline;
      final updated = Pipeline(
        id: current.id,
        name: current.name,
        tasks: current.tasks.map((t) {
          if (t.id == event.taskId) {
            return Task(
              id: t.id,
              name: t.name,
              order: t.order,
              status: event.status,
            );
          }
          return t;
        }).toList(),
      );
      emit(PipelineLoaded(updated));
    }
  }
}
