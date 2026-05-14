import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

class _MockRepo implements PipelineRepository {
  @override
  Future<Pipeline> fetch(String id) async => _testPipeline;
}

class _EmptyRepo implements PipelineRepository {
  @override
  Future<Pipeline> fetch(String id) async => Pipeline(
    id: '1',
    name: 'empty',
    title: 'Empty',
    tasks: [],
  );
}

final _testPipeline = Pipeline(
  id: '1',
  name: 'test-pipeline',
  title: 'Test Pipeline',
  tasks: [
    Task(id: 's1', name: 'step/1', title: '第一步', status: TaskStatus.completed),
    Task(id: 's2', name: 'step/2', title: '第二步', status: TaskStatus.inProgress),
    Task(id: 's3', name: 'step/3', title: '第三步', status: TaskStatus.pending),
  ],
);

class _TestErrorBloc extends PipelineBloc {
  _TestErrorBloc() : super(repository: _MockRepo());

  void showError(String message) {
    emit(PipelineLoadFailed(message));
  }
}

void main() {
  group('DataScreen', () {
    testWidgets('renders all tasks in a row', (tester) async {
      final repo = _MockRepo();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataScreen(pipelineId: '1', repository: repo),
          ),
        ),
      );

      // wait for async load
      await tester.pumpAndSettle();

      expect(find.text('第一步'), findsOneWidget);
      expect(find.text('第二步'), findsOneWidget);
      expect(find.text('第三步'), findsOneWidget);
      expect(find.text('达标'), findsOneWidget);
      expect(find.text('进行中'), findsOneWidget);
      expect(find.text('就绪'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
    });

    testWidgets('shows error message on error', (tester) async {
      final bloc = _TestErrorBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataScreen(
              pipelineId: '1',
              repository: _MockRepo(),
              bloc: bloc,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      bloc.showError('加载失败');
      await tester.pumpAndSettle();

      expect(find.text('加载失败'), findsOneWidget);
    });

    testWidgets('renders datasets section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataScreen(
              pipelineId: '1',
              repository: _MockRepo(),
              datasets: [
                Dataset(id: 'd1', name: 'test/ds', title: '测试数据集', schemaId: 's1', status: DatasetStatus.ready),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('数据集'), findsOneWidget);
      expect(find.text('test/ds'), findsOneWidget);
      expect(find.text('已就绪'), findsOneWidget);
    });

    testWidgets('renders nothing for empty pipeline', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataScreen(pipelineId: '1', repository: _EmptyRepo()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsNothing);
      expect(find.byType(TaskCard), findsNothing);
    });
  });
}
