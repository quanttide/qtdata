import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/widgets/matrix_card.dart';

import '../helpers/seed.dart';

void main() {
  testWidgets('渲染表头/行标签/单元格/图例', (tester) async {
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatrixCard(matrix: project.matrix),
          ),
        ),
      ),
    );

    expect(find.text('全流程进度总览'), findsOneWidget);
    expect(find.text('维度 \\ 阶段'), findsOneWidget);
    // 阶段列头（调研/谈判/实施/验收/复盘）+ 状态标签
    for (final label in ['调研', '谈判', '实施', '验收', '复盘']) {
      expect(find.text(label), findsWidgets);
    }
    // 维度行标签
    expect(find.text('📋 项目'), findsOneWidget);
    expect(find.text('📊 数据'), findsOneWidget);
    expect(find.text('💼 商务'), findsOneWidget);
    // 单元格内容
    expect(find.text('数据需求文档（DRD）'), findsOneWidget);
    // 图例
    expect(find.text('已完成'), findsWidgets);
    expect(find.text('待启动'), findsWidgets);
  });
}
