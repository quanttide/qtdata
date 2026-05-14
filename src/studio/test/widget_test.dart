import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/main.dart' as app;

void main() {
  testWidgets('app renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: app.HomePage()));
    await tester.pumpAndSettle();

    expect(find.text('看板'), findsOneWidget);
    expect(find.text('数据'), findsOneWidget);
  });
}
