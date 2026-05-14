import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('ApiClient', () {
    test('fetchTasks parses camelCase JSON', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response.bytes(
            utf8.encode(jsonEncode([
              {
                'id': 't1',
                'title': 'Test',
                'type': 'requirement',
                'status': 'pending',
                'createdAt': '2026-05-13T00:00:00Z',
              },
            ])),
            200,
          );
        }),
      );

      final tasks = await api.fetchTasks();
      expect(tasks.length, 1);
      expect(tasks[0].id, 't1');
      expect(tasks[0].title, 'Test');
      expect(tasks[0].type, 'requirement');
    });

    test('fetchTasks throws on non-200', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response('{}', 500);
        }),
      );
      expect(api.fetchTasks(), throwsException);
    });

    test('fetchProjects returns project list', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response.bytes(
            utf8.encode(jsonEncode([
              {
                'id': 'p1',
                'name': 'test',
                'title': 'Test Project',
              },
            ])),
            200,
          );
        }),
      );
      final projects = await api.fetchProjects();
      expect(projects.length, 1);
      expect(projects[0].id, 'p1');
    });
  });

  group('BoardBloc', () {
    test('load emits BoardLoaded on success', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response.bytes(
            utf8.encode(jsonEncode([
              {'id': 't1', 'title': 'Task 1', 'type': 'requirement'},
              {'id': 't2', 'title': 'Task 2', 'type': 'execution'},
            ])),
            200,
          );
        }),
      );
      final bloc = BoardBloc(api: api);

      expectLater(
        bloc.stream,
        emitsInOrder([isA<BoardLoading>(), isA<BoardLoaded>()]),
      );

      bloc.add(LoadBoard());
      await bloc.stream.first;
      await bloc.close();
    });

    test('load emits BoardError on failure', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          return http.Response('{}', 500);
        }),
      );
      final bloc = BoardBloc(api: api);

      expectLater(
        bloc.stream,
        emitsInOrder([isA<BoardLoading>(), isA<BoardError>()]),
      );

      bloc.add(LoadBoard());
      await bloc.stream.first;
      await bloc.close();
    });
  });
}
