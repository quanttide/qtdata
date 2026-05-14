import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('TaskCard', () {
    testWidgets('renders task name and status label', (tester) async {
      final task = Task(
        id: '1',
        name: '导入销售订单',
        order: 1,
        status: TaskStatus.completed,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      expect(find.text('导入销售订单'), findsOneWidget);
      expect(find.text('达标'), findsOneWidget);
    });

    testWidgets('renders running status label', (tester) async {
      final task = Task(
        id: '1',
        name: '计算客户RFM',
        order: 1,
        status: TaskStatus.running,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      expect(find.text('执行中'), findsOneWidget);
    });

    testWidgets('renders failed status label', (tester) async {
      final task = Task(
        id: '1',
        name: '清洗订单数据',
        order: 1,
        status: TaskStatus.failed,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      expect(find.text('异常'), findsOneWidget);
    });
  });
}
