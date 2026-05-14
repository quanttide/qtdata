import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('ProjectBoard', () {
    final tasks = [
      Task.fromJson(<String, dynamic>{
        'id': '1', 'title': '需求1', 'type': 'requirement', 'status': 'pending',
      }),
      Task.fromJson(<String, dynamic>{
        'id': '2', 'title': '需求2', 'type': 'requirement', 'status': 'done',
      }),
      Task.fromJson(<String, dynamic>{
        'id': '3', 'title': '约定1', 'type': 'agreement', 'status': 'pending',
      }),
      Task.fromJson(<String, dynamic>{
        'id': '4', 'title': '执行1', 'type': 'execution', 'status': 'active',
      }),
      Task.fromJson(<String, dynamic>{
        'id': '5', 'title': '验收1', 'type': 'acceptance', 'status': 'done',
      }),
    ];

    final board = ProjectBoard(tasks: tasks);

    test('requirement returns only requirement tasks', () {
      expect(board.requirement.length, 2);
      expect(board.requirement.every((t) => t.type == 'requirement'), isTrue);
    });

    test('agreement returns only agreement tasks', () {
      expect(board.agreement.length, 1);
      expect(board.agreement[0].type, 'agreement');
    });

    test('execution returns only execution tasks', () {
      expect(board.execution.length, 1);
      expect(board.execution[0].type, 'execution');
    });

    test('acceptance returns only acceptance tasks', () {
      expect(board.acceptance.length, 1);
      expect(board.acceptance[0].type, 'acceptance');
    });

    test('empty tasks returns empty lists for all getters', () {
      final empty = ProjectBoard(tasks: []);
      expect(empty.requirement, isEmpty);
      expect(empty.agreement, isEmpty);
      expect(empty.execution, isEmpty);
      expect(empty.acceptance, isEmpty);
    });
  });
}
