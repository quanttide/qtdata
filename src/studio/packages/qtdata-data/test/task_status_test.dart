import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('TaskStatus', () {
    test('pending is the default value', () {
      expect(TaskStatus.pending.index, 0);
    });

    test('values contain all four statuses', () {
      expect(TaskStatus.values, [
        TaskStatus.pending,
        TaskStatus.running,
        TaskStatus.completed,
        TaskStatus.failed,
      ]);
    });
  });
}
