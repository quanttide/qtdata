import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/widgets/cards/project_card.dart';

import '../helpers/seed.dart';

void main() {
  testWidgets('渲染项目名称/状态/阶段/仪表/收入', (tester) async {
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProjectCard(project: project, onTap: () {}),
        ),
      ),
    );

    expect(find.text('量潮科技数字化'), findsOneWidget);
    // 状态徽章 + 仪表标签均为「进行中」
    expect(find.text('进行中'), findsNWidgets(2));
    expect(find.text('实施阶段'), findsOneWidget);
    expect(find.text('更新于 2026-08-08'), findsOneWidget);
    // 交付物仪表：3 完成 / 1 进行中 / 0 待启动，共 4 项
    expect(find.text('3'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('共 4 项'), findsOneWidget);
    // 完成度与确认收入（0.8 万 × 75% = 0.6 万）
    expect(find.text('75%'), findsOneWidget);
    expect(find.textContaining('0.6'), findsOneWidget);
    expect(find.textContaining('0.8 万元'), findsOneWidget);
  });

  testWidgets('点击触发 onTap', (tester) async {
    final project = loadSeedProject();
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProjectCard(project: project, onTap: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.text('量潮科技数字化'));
    expect(tapped, isTrue);
  });
}
