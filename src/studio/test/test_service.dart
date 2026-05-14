import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

import 'package:qtdata_project/qtdata_project.dart';

final _mockTasks = [
  {'id': 't1', 'title': '测试任务', 'type': 'requirement', 'status': 'pending'},
  {'id': 't2', 'title': '执行任务', 'type': 'execution', 'status': 'doing'},
];

Widget _buildApp(ApiClient api) {
  return MaterialApp(
    home: ProjectBoardScreen(apiClient: api),
  );
}

void main() {
  testWidgets('loads and displays tasks from server', (tester) async {
    final api = ApiClient(
      client: MockClient((_) async =>
          http.Response.bytes(utf8.encode(jsonEncode(_mockTasks)), 200)),
    );

    await tester.pumpWidget(_buildApp(api));
    await tester.pumpAndSettle();

    expect(find.text('测试任务'), findsWidgets);
    expect(find.text('执行任务'), findsWidgets);
  });

  testWidgets('shows error on failure', (tester) async {
    final api = ApiClient(
      client: MockClient((_) async => http.Response('{}', 500)),
    );

    await tester.pumpWidget(_buildApp(api));
    await tester.pumpAndSettle();

    expect(find.textContaining('加载失败'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });
}
