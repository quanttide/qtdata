import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/widgets/status_badge.dart';

void main() {
  testWidgets('三态状态渲染对应配色', (tester) async {
    const cases = {
      '已完成': Color(0xFFD1FAE5),
      '进行中': Color(0xFFDBEAFE),
      '待启动': Color(0xFFFEF3C7),
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StatusBadge(status: entry.key)),
        ),
      );

      expect(find.text(entry.key), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text(entry.key),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, entry.value);
    }
  });
}
