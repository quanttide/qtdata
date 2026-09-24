import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:qtdata_studio/app/screens/project_detail_screen.dart';
import 'package:qtdata_studio/main.dart' as app;

/// 最短业务流：启动 → 看板看到项目 → 进详情 → 切 Tab。
///
/// 边界见 integration_test/README.md：Flutter 进程内端到端，
/// 不与 `test/`（部件级）和仓库根 `tests/`（跨进程 xdotool）重叠。
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('启动 → 看板 → 详情 → 切资产 Tab', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // 真实加载 seed JSON 后列表可见
    expect(find.text('我的项目'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 30));
    expect(find.text('全球法规情报中心'), findsWidgets);

    // 进详情（go_router 站内跳转）
    await tester.tap(find.text('全球法规情报中心').first);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('总览'), findsOneWidget);

    // 切到资产 Tab，资产页内容可见
    await tester.tap(find.text('资产'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('点击资产条目查看资料'), findsOneWidget);
  });
}
