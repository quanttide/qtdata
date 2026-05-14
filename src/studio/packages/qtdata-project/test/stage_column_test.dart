import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('StageColumn', () {
    testWidgets('shows placeholder when tasks is empty', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StageColumn(
            icon: Icons.search,
            title: '需求探索',
            tasks: const [],
            cardBuilder: (_) => const SizedBox(),
          ),
        ),
      ));

      expect(find.text('需求探索'), findsOneWidget);
      expect(find.text('0 项'), findsOneWidget);
      expect(find.text('暂无任务'), findsOneWidget);
    });

    testWidgets('renders task cards when tasks is not empty', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StageColumn(
            icon: Icons.search,
            title: '需求探索',
            tasks: [
              Task.fromJson(<String, dynamic>{
                'id': '1', 'title': '需求1', 'type': 'requirement', 'status': 'pending',
              }),
              Task.fromJson(<String, dynamic>{
                'id': '2', 'title': '需求2', 'type': 'requirement', 'status': 'done',
              }),
            ],
            cardBuilder: (task) => Text('card: ${task.title}'),
          ),
        ),
      ));

      expect(find.text('需求探索'), findsOneWidget);
      expect(find.text('2 项'), findsOneWidget);
      expect(find.textContaining('card:'), findsNWidgets(2));
    });
  });
}
