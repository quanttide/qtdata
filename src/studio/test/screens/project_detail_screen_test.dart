import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/screens/project_detail_screen.dart';
import 'package:qtdata_studio/widgets/common/sidebar.dart';

import '../helpers/seed.dart';

/// 调大视口让 ListView 一次性 build 全部卡片，避免懒加载裁剪
void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('渲染头部与三大卡片', (tester) async {
    _useTallViewport(tester);
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(home: ProjectDetailScreen(project: project)),
    );
    await tester.pumpAndSettle();

    // 共享组件
    expect(find.byType(Sidebar), findsOneWidget);
    expect(find.text('量'), findsOneWidget);
    // 头部
    expect(find.text('量潮科技数字化'), findsOneWidget);
    expect(find.text('进行中'), findsWidgets); // 徽章 + 矩阵状态标签
    expect(find.text('实施'), findsNWidgets(2)); // PhaseTag + 矩阵列头
    expect(find.textContaining('客户：量潮科技（内部项目）'), findsOneWidget);
    // 三大卡片
    expect(find.text('全流程进度总览'), findsOneWidget);
    expect(find.text('完整数据蓝图'), findsOneWidget);
    expect(find.text('交付时间线'), findsOneWidget);
    expect(find.text('处理流程'), findsOneWidget);
    expect(find.text('异常处理预案'), findsOneWidget);
    expect(find.text('维度 \\ 阶段'), findsOneWidget);
    expect(find.text('数据采集'), findsOneWidget);
  });

  testWidgets('查看资料弹窗可打开关闭', (tester) async {
    _useTallViewport(tester);
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(home: ProjectDetailScreen(project: project)),
    );
    await tester.pumpAndSettle();

    // 打开第一个有文档的交付物
    await tester.tap(find.text('查看资料').first);
    await tester.pumpAndSettle();
    expect(find.text('以下资料可供下载：'), findsOneWidget);

    // 关闭
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('以下资料可供下载：'), findsNothing);
  });

  testWidgets('导出按钮弹出 toast', (tester) async {
    _useTallViewport(tester);
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(home: ProjectDetailScreen(project: project)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('导出'));
    await tester.pumpAndSettle();
    expect(find.text('📄 报告已导出'), findsOneWidget);
  });
}
