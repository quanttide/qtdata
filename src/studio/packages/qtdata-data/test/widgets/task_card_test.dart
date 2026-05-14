import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('TaskCard', () {
    testWidgets('renders task title and status label', (tester) async {
      final task = Task(
        id: '1',
        name: 'import/sales-orders',
        title: '导入销售订单',
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
        id: '2',
        name: 'compute/customer-rfm',
        title: '计算客户RFM',
        status: TaskStatus.inProgress,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      expect(find.text('进行中'), findsOneWidget);
    });

    testWidgets('renders failed status label', (tester) async {
      final task = Task(
        id: '3',
        name: 'cleanse/order-data',
        title: '清洗订单数据',
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

    testWidgets('renders rejected status label', (tester) async {
      final task = Task(
        id: '4',
        name: 'review/result',
        title: '审核结果',
        status: TaskStatus.rejected,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      expect(find.text('驳回'), findsOneWidget);
    });

    testWidgets('renders cancelled status label', (tester) async {
      final task = Task(
        id: '5',
        name: 'cleanse/order-data',
        title: '清洗订单数据',
        status: TaskStatus.cancelled,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: task),
          ),
        ),
      );

      expect(find.text('取消'), findsOneWidget);
    });
  });
}
