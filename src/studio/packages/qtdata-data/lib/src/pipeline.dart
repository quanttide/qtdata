import 'task.dart';
import 'task_status.dart';

class Pipeline {
  final String id;
  final String name;
  final List<Task> tasks;

  const Pipeline({
    required this.id,
    required this.name,
    required this.tasks,
  });

  TaskStatus get derivedStatus {
    if (tasks.isEmpty) return TaskStatus.pending;
    if (tasks.every((t) => t.status == TaskStatus.completed)) {
      return TaskStatus.completed;
    }
    if (tasks.any((t) => t.status == TaskStatus.failed)) {
      return TaskStatus.failed;
    }
    if (tasks.any((t) => t.status == TaskStatus.running)) {
      return TaskStatus.running;
    }
    return TaskStatus.pending;
  }
}
