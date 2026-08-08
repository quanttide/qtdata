import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/screens/dashboard_screen.dart';
import 'package:qtdata_studio/screens/project_detail_screen.dart';
import 'package:qtdata_studio/widgets/common/sidebar.dart';

import '../helpers/seed.dart';

/// 手机视口（iPhone 逻辑尺寸）
void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('首页移动端：隐藏侧栏，项目列表正常渲染', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 2)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Sidebar), findsNothing);
    expect(find.text('量潮科技数字化'), findsWidgets);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('我的项目'), findsOneWidget);
  });

  testWidgets('详情页移动端：隐藏侧栏，Tab 可横滑切换', (tester) async {
    _usePhoneViewport(tester);
    final project = loadSeedProject();
    await tester.pumpWidget(
      MaterialApp(home: ProjectDetailScreen(project: project)),
    );
    await tester.pumpAndSettle();

    // 无侧栏；默认总览页
    expect(find.byType(Sidebar), findsNothing);
    expect(find.text('75%'), findsOneWidget);

    // 5 个 Tab 都在（TabBar 可横滑）
    for (final t in ['总览', '数据', '项目', '商务', '资产']) {
      expect(find.text(t), findsOneWidget);
    }

    // 滚动 TabBar 到「资产」并切换
    await tester.scrollUntilVisible(
      find.text('资产'),
      100,
      scrollable: find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('资产'));
    await tester.pumpAndSettle();
    expect(find.text('维度 \\ 阶段'), findsOneWidget);

    // 切回数据
    await tester.scrollUntilVisible(
      find.text('数据'),
      -100,
      scrollable: find.descendant(
        of: find.byType(TabBar),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('数据'));
    await tester.pumpAndSettle();
    expect(find.text('完整数据蓝图'), findsOneWidget);
  });
}
