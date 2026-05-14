import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('ProjectBoardState', () {
    test('load loads tasks on success', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response.bytes(
            utf8.encode(jsonEncode([
              {'id': 't1', 'title': 'Task 1', 'type': 'requirement'},
            ])),
            200,
          );
        }),
      );
      final state = ProjectBoardState(api: api);

      expect(state.loading, false);
      expect(state.board.tasks, isEmpty);

      await state.load();

      expect(state.loading, false);
      expect(state.error, isNull);
      expect(state.board.tasks.length, 1);
    });

    test('load sets error on failure', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response('{}', 500);
        }),
      );
      final state = ProjectBoardState(api: api);

      await state.load();

      expect(state.loading, false);
      expect(state.error, isNotNull);
      expect(state.board.tasks, isEmpty);
    });

    test('load notifies listeners', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response.bytes(
            utf8.encode(jsonEncode([])),
            200,
          );
        }),
      );
      final state = ProjectBoardState(api: api);
      int notifyCount = 0;
      state.addListener(() => notifyCount++);

      await state.load();

      expect(notifyCount, greaterThan(0));
    });
  });
}
