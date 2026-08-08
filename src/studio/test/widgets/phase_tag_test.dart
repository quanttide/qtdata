import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/models/project.dart';
import 'package:qtdata_studio/widgets/phase_tag.dart';

void main() {
  testWidgets('五个阶段渲染对应文案与配色', (tester) async {
    const cases = {
      ProjectPhase.research: (Color(0xFFDBEAFE), '调研'),
      ProjectPhase.negotiate: (Color(0xFFFEF3C7), '谈判'),
      ProjectPhase.implement: (Color(0xFFD1FAE5), '实施'),
      ProjectPhase.accept: (Color(0xFFEDE9FE), '验收'),
      ProjectPhase.review: (Color(0xFFFCE7F3), '复盘'),
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PhaseTag(phase: entry.key)),
        ),
      );

      expect(find.text(entry.value.$2), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text(entry.value.$2),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, entry.value.$1);
    }
  });

  testWidgets('withSuffix 追加「阶段」后缀', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PhaseTag(phase: ProjectPhase.implement, withSuffix: true),
        ),
      ),
    );

    expect(find.text('实施阶段'), findsOneWidget);
  });
}
