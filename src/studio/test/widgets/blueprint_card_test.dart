import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/widgets/blueprint_card.dart';

import '../helpers/seed.dart';

void main() {
  testWidgets('渲染处理流程与异常预案', (tester) async {
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BlueprintCard(blueprint: project.blueprint),
          ),
        ),
      ),
    );

    expect(find.text('完整数据蓝图'), findsOneWidget);
    expect(find.text('处理流程'), findsOneWidget);
    expect(find.text('异常处理预案'), findsOneWidget);
    // 7 个步骤（含编号圆点）
    expect(find.textContaining('采集原始数据'), findsOneWidget);
    expect(find.textContaining('周会报告'), findsOneWidget);
    // 4 个异常预案
    expect(find.text('无责任人'), findsOneWidget);
    expect(find.text('编号双轨'), findsOneWidget);
    expect(find.textContaining('标记"未指定"'), findsOneWidget);
  });
}
