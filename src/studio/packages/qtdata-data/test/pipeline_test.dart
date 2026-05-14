import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('Pipeline', () {
    group('derivedStatus with empty tasks', () {
      test('returns pending', () {
        final pipeline = Pipeline(id: '1', name: 'empty', tasks: []);
        expect(pipeline.derivedStatus, TaskStatus.pending);
      });
    });

    group('derivedStatus with all tasks completed', () {
      test('returns completed', () {
        final pipeline = Pipeline(
          id: '1',
          name: 'all done',
          tasks: [
            Task(id: '1', name: 'a', order: 1, status: TaskStatus.completed),
            Task(id: '2', name: 'b', order: 2, status: TaskStatus.completed),
          ],
        );
        expect(pipeline.derivedStatus, TaskStatus.completed);
      });
    });

    group('derivedStatus with any failed', () {
      test('returns failed regardless of other statuses', () {
        final pipeline = Pipeline(
          id: '1',
          name: 'has failure',
          tasks: [
            Task(id: '1', name: 'a', order: 1, status: TaskStatus.completed),
            Task(id: '2', name: 'b', order: 2, status: TaskStatus.failed),
            Task(id: '3', name: 'c', order: 3, status: TaskStatus.running),
          ],
        );
        expect(pipeline.derivedStatus, TaskStatus.failed);
      });
    });

    group('derivedStatus with any running', () {
      test('returns running when none failed', () {
        final pipeline = Pipeline(
          id: '1',
          name: 'in progress',
          tasks: [
            Task(id: '1', name: 'a', order: 1, status: TaskStatus.completed),
            Task(id: '2', name: 'b', order: 2, status: TaskStatus.running),
            Task(id: '3', name: 'c', order: 3, status: TaskStatus.pending),
          ],
        );
        expect(pipeline.derivedStatus, TaskStatus.running);
      });
    });

    group('derivedStatus with all pending', () {
      test('returns pending', () {
        final pipeline = Pipeline(
          id: '1',
          name: 'all pending',
          tasks: [
            Task(id: '1', name: 'a', order: 1),
            Task(id: '2', name: 'b', order: 2),
          ],
        );
        expect(pipeline.derivedStatus, TaskStatus.pending);
      });
    });
  });
}
