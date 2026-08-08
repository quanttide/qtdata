import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/widgets/common/sidebar.dart';

void main() {
  testWidgets('渲染 logo 与导航图标', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Sidebar())));

    expect(find.text('量'), findsOneWidget);
    expect(find.byIcon(Icons.space_dashboard_outlined), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });

  testWidgets('active 高亮仪表盘图标，help 保持灰态', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Sidebar())));

    final dashboard = tester.widget<Icon>(
      find.byIcon(Icons.space_dashboard_outlined),
    );
    expect(dashboard.color, const Color(0xFF4F46E5));

    final help = tester.widget<Icon>(find.byIcon(Icons.help_outline));
    expect(help.color, const Color(0xFF94A3B8));
  });
}
