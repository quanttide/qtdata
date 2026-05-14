import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('PipelineBloc', () {
    test('initial state is PipelineInitial', () {
      final bloc = PipelineBloc();
      expect(bloc.state, isA<PipelineInitial>());
      bloc.close();
    });

    test('LoadPipeline emits PipelineLoaded with the pipeline', () async {
      final bloc = PipelineBloc();
      final pipeline = Pipeline(
        id: '1',
        name: 'test',
        tasks: [Task(id: 't1', name: 'task1', order: 1)],
      );

      bloc.add(LoadPipeline(pipeline));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      bloc.close();
    });

    test('UpdateTaskStatus updates the correct task status', () async {
      final bloc = PipelineBloc();
      final pipeline = Pipeline(
        id: '1',
        name: 'test',
        tasks: [
          Task(id: 't1', name: 'task1', order: 1),
          Task(id: 't2', name: 'task2', order: 2, status: TaskStatus.running),
        ],
      );

      bloc.add(LoadPipeline(pipeline));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      bloc.add(UpdateTaskStatus('t1', TaskStatus.completed));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      final loaded = bloc.state as PipelineLoaded;
      expect(loaded.pipeline.tasks[0].status, TaskStatus.completed);
      expect(loaded.pipeline.tasks[1].status, TaskStatus.running);

      bloc.close();
    });

    test('UpdateTaskStatus ignores non-existent task ids', () async {
      final bloc = PipelineBloc();
      final pipeline = Pipeline(
        id: '1',
        name: 'test',
        tasks: [Task(id: 't1', name: 'task1', order: 1)],
      );

      bloc.add(LoadPipeline(pipeline));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      bloc.add(UpdateTaskStatus('nonexistent', TaskStatus.completed));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      final loaded = bloc.state as PipelineLoaded;
      expect(loaded.pipeline.tasks[0].status, TaskStatus.pending);

      bloc.close();
    });

    test('UpdateTaskStatus does nothing before LoadPipeline', () async {
      final bloc = PipelineBloc();

      bloc.add(UpdateTaskStatus('t1', TaskStatus.completed));
      // small delay to ensure no emission from initial state
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<PipelineInitial>());

      bloc.close();
    });

    test('LoadPipeline replaces existing state', () async {
      final bloc = PipelineBloc();
      final pipeline1 = Pipeline(
        id: '1',
        name: 'first',
        tasks: [Task(id: 't1', name: 'task1', order: 1)],
      );
      final pipeline2 = Pipeline(
        id: '2',
        name: 'second',
        tasks: [Task(id: 't2', name: 'task2', order: 1)],
      );

      bloc.add(LoadPipeline(pipeline1));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      bloc.add(LoadPipeline(pipeline2));
      await expectLater(
        bloc.stream,
        emits(isA<PipelineLoaded>()),
      );

      final loaded = bloc.state as PipelineLoaded;
      expect(loaded.pipeline.id, '2');

      bloc.close();
    });
  });
}
