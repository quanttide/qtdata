import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('PipelineScreen', () {
    testWidgets('renders all tasks in a row', (tester) async {
      final pipeline = Pipeline(
        id: '1',
        name: 'test-pipeline',
        title: 'Test Pipeline',
        tasks: [
          Task(id: 's1', name: 'step/1', title: '第一步', status: TaskStatus.completed),
          Task(id: 's2', name: 'step/2', title: '第二步', status: TaskStatus.inProgress),
          Task(id: 's3', name: 'step/3', title: '第三步', status: TaskStatus.pending),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineScreen(pipeline: pipeline),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('第一步'), findsOneWidget);
      expect(find.text('第二步'), findsOneWidget);
      expect(find.text('第三步'), findsOneWidget);
      expect(find.text('达标'), findsOneWidget);
      expect(find.text('进行中'), findsOneWidget);
      expect(find.text('就绪'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
    });

    testWidgets('renders nothing for empty pipeline', (tester) async {
      final pipeline = Pipeline(
        id: '1',
        name: 'empty-pipeline',
        title: 'Empty',
        tasks: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PipelineScreen(pipeline: pipeline),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsNothing);
      expect(find.byType(TaskCard), findsNothing);
    });
  });
}
