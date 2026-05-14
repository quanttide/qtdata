import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('PipelineScreen', () {
    testWidgets('renders all tasks in a row', (tester) async {
      final pipeline = Pipeline(
        id: '1',
        name: '数据处理流程',
        tasks: [
          Task(id: 's1', name: '第一步', order: 1, status: TaskStatus.completed),
          Task(id: 's2', name: '第二步', order: 2, status: TaskStatus.running),
          Task(id: 's3', name: '第三步', order: 3, status: TaskStatus.pending),
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
      expect(find.text('执行中'), findsOneWidget);
      expect(find.text('就绪'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
    });
  });
}
