import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/screens/dashboard_screen.dart';

void main() {
  testWidgets('从 seed JSON 异步加载并渲染项目', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    // 初始加载态
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 真实异步 IO：等待 rootBundle 加载 seed JSON
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 2)),
    );
    await tester.pumpAndSettle();

    // 统计卡片（全部 1 / 进行中 1 / 已完成 0 / 待启动 0）+
    // 卡片仪表待启动 0（todoItems）
    expect(find.text('1'), findsWidgets);
    expect(find.text('0'), findsNWidgets(3));
    // 项目卡片
    expect(find.text('量潮科技数字化'), findsWidgets);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('种子数据加载失败'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
