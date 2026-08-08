import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/screens/project_detail_screen.dart';
import 'package:qtdata_studio/widgets/common/sidebar.dart';

import '../helpers/seed.dart';

/// 调大视口让 ListView 一次性 build 全部内容，避免懒加载裁剪
void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _pumpDetail(WidgetTester tester) async {
  _useTallViewport(tester);
  final project = loadSeedProject();
  await tester.pumpWidget(
    MaterialApp(home: ProjectDetailScreen(project: project)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('渲染头部与 5 个 Tab，默认显示数据页', (tester) async {
    await _pumpDetail(tester);

    // 共享组件与头部
    expect(find.byType(Sidebar), findsOneWidget);
    expect(find.text('量潮科技数字化'), findsWidgets);
    expect(find.text('进行中'), findsWidgets);
    expect(find.textContaining('客户：量潮科技（内部项目）'), findsOneWidget);

    // 5 个 Tab（数据第一，资产最后）
    expect(find.text('数据'), findsWidgets);
    expect(find.text('仪表盘'), findsOneWidget);
    expect(find.text('项目'), findsOneWidget);
    expect(find.text('商务'), findsOneWidget);
    expect(find.text('资产'), findsOneWidget);

    // 默认数据页：完整数据蓝图
    expect(find.text('完整数据蓝图'), findsOneWidget);
    expect(find.text('异常处理预案'), findsOneWidget);
    expect(find.text('75%'), findsNothing); // 仪表盘内容不在默认页
  });

  testWidgets('切换 Tab 显示对应内容', (tester) async {
    await _pumpDetail(tester);

    // 默认数据：仅蓝图（不含时间线）
    expect(find.text('完整数据蓝图'), findsOneWidget);
    expect(find.text('异常处理预案'), findsOneWidget);
    expect(find.text('交付时间线'), findsNothing);

    // 仪表盘：项目摘要 + 交付物明细
    await tester.tap(find.text('仪表盘'));
    await tester.pumpAndSettle();
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('交付物明细'), findsOneWidget);

    // 项目：基本信息 + 交付时间线（项目管理信息）
    await tester.tap(find.text('项目'));
    await tester.pumpAndSettle();
    expect(find.text('项目信息'), findsOneWidget);
    expect(find.text('交付时间线'), findsOneWidget);
    expect(find.text('数据采集'), findsOneWidget);
    expect(find.text('客户'), findsOneWidget); // 信息行标签

    // 商务：交易四段 + 商务管理阶段
    await tester.tap(find.text('商务'));
    await tester.pumpAndSettle();
    for (final t in ['报价', '合同', '交付', '结款']) {
      expect(find.text(t), findsOneWidget);
    }
    expect(find.text('商务管理阶段'), findsOneWidget);
    expect(find.text('调研'), findsOneWidget); // 商务阶段步骤
    expect(find.text('首付款'), findsOneWidget);
    expect(find.text('尾款'), findsOneWidget);
    expect(find.textContaining('已收 0.4 / 0.8 万'), findsOneWidget);

    // 资产（最后）：矩阵
    await tester.tap(find.text('资产'));
    await tester.pumpAndSettle();
    expect(find.text('维度 \\ 阶段'), findsOneWidget);
    expect(find.text('数据需求文档（DRD）'), findsOneWidget);
    expect(find.text('点击资产条目查看资料'), findsOneWidget);
  });

  testWidgets('资产单元格点击打开资料弹窗', (tester) async {
    await _pumpDetail(tester);

    await tester.tap(find.text('资产'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('数据需求文档（DRD）'));
    await tester.pumpAndSettle();
    expect(find.text('以下资料可供下载：'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('以下资料可供下载：'), findsNothing);
  });

  testWidgets('项目 Tab 的查看资料打开弹窗', (tester) async {
    await _pumpDetail(tester);

    await tester.tap(find.text('项目'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('查看资料').first);
    await tester.pumpAndSettle();
    expect(find.text('以下资料可供下载：'), findsOneWidget);
  });

  testWidgets('导出按钮弹出 toast', (tester) async {
    await _pumpDetail(tester);

    await tester.tap(find.text('导出'));
    await tester.pumpAndSettle();
    expect(find.text('📄 报告已导出'), findsOneWidget);
  });
}
