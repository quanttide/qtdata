import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('ProjectBoardScreen', () {
    testWidgets('shows board columns on load success', (tester) async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response.bytes(
            utf8.encode(jsonEncode([
              {'id': 't1', 'title': 'Task 1', 'type': 'requirement', 'status': 'pending', 'description': '需求描述'},
              {'id': 't2', 'title': 'Task 2', 'type': 'agreement', 'status': 'done'},
            ])),
            200,
          );
        }),
      );

      await tester.pumpWidget(MaterialApp(
        home: ProjectBoardScreen(apiClient: api),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.text('量潮数据'), findsOneWidget);
      expect(find.text('需求探索'), findsOneWidget);
      expect(find.text('约定启动'), findsOneWidget);
      expect(find.text('执行监控'), findsOneWidget);
      expect(find.text('验收交付'), findsOneWidget);
    });

    testWidgets('shows error on load failure', (tester) async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response('{}', 500);
        }),
      );

      await tester.pumpWidget(MaterialApp(
        home: ProjectBoardScreen(apiClient: api),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('加载失败'), findsOneWidget);
      expect(find.text('重试'), findsOneWidget);
    });

    testWidgets('retry button triggers reload', (tester) async {
      int requestCount = 0;
      final api = ApiClient(
        client: MockClient((request) async {
          requestCount++;
          return http.Response('{}', 500);
        }),
      );

      await tester.pumpWidget(MaterialApp(
        home: ProjectBoardScreen(apiClient: api),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.text('重试'), findsOneWidget);
      expect(requestCount, 1);

      await tester.tap(find.text('重试'));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('加载失败'), findsOneWidget);
      expect(find.text('重试'), findsOneWidget);
      expect(requestCount, 2);
    });

    testWidgets('shows loading indicator during load', (tester) async {
      final completer = Completer<http.Response>();
      final api = ApiClient(
        client: MockClient((_) => completer.future),
      );

      await tester.pumpWidget(MaterialApp(
        home: ProjectBoardScreen(apiClient: api),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(http.Response.bytes(
        utf8.encode(jsonEncode([])),
        200,
      ));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
