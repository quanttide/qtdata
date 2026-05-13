import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qtdata_project/qtdata_project.dart';
import 'package:qtdata_studio/main.dart' as app;

void main() {
  testWidgets('app renders title', (WidgetTester tester) async {
    final api = ApiClient(
      client: MockClient((_) async =>
          http.Response.bytes(utf8.encode('[]'), 200)),
    );

    await tester.pumpWidget(app.QtDataStudio(apiClient: api));
    await tester.pumpAndSettle();

    expect(find.text('量潮数据'), findsOneWidget);
  });
}
