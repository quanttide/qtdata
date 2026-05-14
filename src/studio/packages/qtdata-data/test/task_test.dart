import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('Task', () {
    test('default status is pending', () {
      final task = Task(id: '1', name: 'test', order: 1);
      expect(task.status, TaskStatus.pending);
    });

    test('can be created with custom status', () {
      final task = Task(
        id: '1',
        name: 'test',
        order: 1,
        status: TaskStatus.running,
      );
      expect(task.status, TaskStatus.running);
    });
  });
}
