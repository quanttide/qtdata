import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

import 'package:qtdata_project/qtdata_project.dart';
import 'package:qtdata_studio/main.dart' as app;

final _mockTasks = [
  {'id': 't1', 'title': '测试任务', 'type': 'requirement', 'status': 'pending'},
  {'id': 't2', 'title': '执行任务', 'type': 'execution', 'status': 'doing'},
];

void main() {
  testWidgets('loads and displays tasks from server', (tester) async {
    final api = ApiClient(
      client: MockClient((_) async =>
          http.Response.bytes(utf8.encode(jsonEncode(_mockTasks)), 200)),
    );

    await tester.pumpWidget(app.QtDataStudio(apiClient: api));
    await tester.pumpAndSettle();

    expect(find.text('测试任务'), findsWidgets);
    expect(find.text('执行任务'), findsWidgets);
  });

  testWidgets('shows error on failure', (tester) async {
    final api = ApiClient(
      client: MockClient((_) async => http.Response('{}', 500)),
    );

    await tester.pumpWidget(app.QtDataStudio(apiClient: api));
    await tester.pumpAndSettle();

    expect(find.textContaining('加载失败'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });
}
