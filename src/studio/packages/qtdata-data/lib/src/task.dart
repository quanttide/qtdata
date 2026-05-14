import 'task_status.dart';

class Task {
  final String id;
  final String name;
  final int order;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.name,
    required this.order,
    this.status = TaskStatus.pending,
  });
}
