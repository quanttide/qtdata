import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('BoardColumnTitle', () {
    testWidgets('renders icon, title, and count', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BoardColumnTitle(
            icon: Icons.search,
            title: '需求探索',
            count: '5 项',
          ),
        ),
      ));

      expect(find.text('需求探索'), findsOneWidget);
      expect(find.text('5 项'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
