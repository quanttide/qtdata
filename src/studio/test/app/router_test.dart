import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:qtdata_studio/app/router.dart';
import 'package:qtdata_studio/app/screens/project_detail_screen.dart';
import 'package:qtdata_studio/project/models/seed_loader.dart';
import 'package:qtdata_studio/project/screens/dashboard_screen.dart';

import '../helpers/seed.dart';

void main() {
  // 同步预灌种子缓存：rootBundle future 在 widget 测试里会悬挂
  // （见 test/helpers/seed.dart 与 seed_loader 的注释），用例不走异步加载。
  setUp(() => setSeedCacheForTest([loadSeedProject()]));

  /// 调大视口让列表/详情一次性 build 全部内容
  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<GoRouter> pumpRouter(WidgetTester tester, String location) async {
    useTallViewport(tester);
    final router = buildRouter(initialLocation: location);
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('入口为 / 时渲染项目列表', (tester) async {
    final router = await pumpRouter(tester, '/');

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byType(ProjectDetailScreen), findsNothing);
    expect(find.text('我的项目'), findsOneWidget);
    expect(router.state.uri.path, '/');
  });

  testWidgets('深链 /projects/:id?tab=business 直达商务 Tab', (tester) async {
    final project = loadSeedProject();
    final router = await pumpRouter(
      tester,
      '/projects/${project.id}?tab=business',
    );

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('全球法规情报中心'), findsWidgets);
    // 商务 Tab 独有内容（报价卡的定价依据），说明 initialTab 生效
    expect(find.text('成本法'), findsOneWidget);
    // 总览 Tab 内容未被构建（TabBarView 只建当前页）
    expect(find.text('交付物明细'), findsNothing);
    expect(router.state.uri.queryParameters['tab'], 'business');
  });

  testWidgets('未知 id 退回列表页', (tester) async {
    await pumpRouter(tester, '/projects/not-exist');

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byType(ProjectDetailScreen), findsNothing);
  });

  testWidgets('列表进详情后点 Tab 同步 ?tab=', (tester) async {
    final router = await pumpRouter(tester, '/');

    await tester.tap(find.text('全球法规情报中心').first);
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(router.state.uri.path, contains('/projects/'));

    await tester.tap(find.text('数据'));
    await tester.pumpAndSettle();
    expect(router.state.uri.queryParameters['tab'], 'data');
    // 数据 Tab 独有内容：完整数据蓝图
    expect(find.text('完整数据蓝图'), findsOneWidget);
    // 切走后总览内容不再构建
    expect(find.text('交付物明细'), findsNothing);
  });

  test('?tab= slug 与下标映射', () {
    expect(detailTabIndex(null), 0);
    expect(detailTabIndex(''), 0);
    expect(detailTabIndex('bogus'), 0);
    expect(detailTabIndex('overview'), 0);
    expect(detailTabIndex('data'), 1);
    expect(detailTabIndex('project'), 2);
    expect(detailTabIndex('business'), 3);
    expect(detailTabIndex('assets'), 4);
    expect(detailTabSlugs, hasLength(5));
  });
}
