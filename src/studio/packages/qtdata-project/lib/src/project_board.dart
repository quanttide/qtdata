import 'package:quanttide_project/quanttide_project.dart';

class ProjectBoard {
  final List<Task> tasks;

  const ProjectBoard({required this.tasks});

  List<Task> get requirement => tasks.where((t) => t.type == 'requirement').toList();
  List<Task> get agreement => tasks.where((t) => t.type == 'agreement').toList();
  List<Task> get execution => tasks.where((t) => t.type == 'execution').toList();
  List<Task> get acceptance => tasks.where((t) => t.type == 'acceptance').toList();
}
