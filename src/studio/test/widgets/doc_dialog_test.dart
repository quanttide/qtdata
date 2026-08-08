import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qtdata_studio/widgets/dialogs/doc_dialog.dart';

import '../helpers/seed.dart';

void main() {
  testWidgets('弹窗展示占位文件并可下载', (tester) async {
    final project = loadSeedProject();
    final item = project.phases.first.items.first; // 飞书议事档案盘点（hasDoc: true）

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  showDocDialog(context, projectName: project.name, item: item),
              child: const Text('打开'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text(item.name), findsWidgets);
    expect(find.textContaining(project.name), findsOneWidget);
    expect(find.text('以下资料可供下载：'), findsOneWidget);
    expect(find.text('${item.name}.pdf'), findsOneWidget);
    expect(find.text('${item.name}_data.csv'), findsOneWidget);

    // 点击下载：弹窗关闭 + toast 提示
    await tester.tap(find.text('下载').first);
    await tester.pumpAndSettle();
    expect(find.text('以下资料可供下载：'), findsNothing);
    expect(find.textContaining('下载 ${item.name}.pdf'), findsOneWidget);
  });
}
