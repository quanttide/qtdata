import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/models/project.dart';
import 'package:qtdata_studio/widgets/cards/timeline_card.dart';

import '../helpers/seed.dart';

void main() {
  testWidgets('渲染阶段与交付物', (tester) async {
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TimelineCard(phases: project.phases),
          ),
        ),
      ),
    );

    expect(find.text('交付时间线'), findsOneWidget);
    for (final name in ['数据采集', '数据建模', '数据导入', '治理输出', '周会报告', '历史周会批量整理']) {
      expect(find.text(name), findsOneWidget);
    }
    // 2 项 × 4 阶段（采集/建模/治理/报告）+ 3 项 × 2 阶段（导入/批量整理）
    expect(find.text('2 项'), findsNWidgets(4));
    expect(find.text('3 项'), findsNWidgets(2));
    // 未传 onViewDoc 时不展示「查看资料」
    expect(find.text('查看资料'), findsNothing);
  });

  testWidgets('点击「查看资料」触发回调', (tester) async {
    final project = loadSeedProject();
    PhaseItem? received;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TimelineCard(
              phases: project.phases,
              onViewDoc: (item) => received = item,
            ),
          ),
        ),
      ),
    );

    // hasDoc 的交付物展示「查看资料」（12 项中 11 项有文档，批量整理阶段 3 项无）
    expect(find.text('查看资料'), findsNWidgets(11));
    await tester.tap(find.text('查看资料').first);
    expect(received, isNotNull);
    expect(received!.hasDoc, isTrue);
  });
}
