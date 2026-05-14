import 'package:flutter/foundation.dart';
import 'package:quanttide_project/quanttide_project.dart';
import '../project_board.dart';
import '../services/api_client.dart';

class ProjectBoardState extends ChangeNotifier {
  final ApiClient _api;

  ProjectBoard board = ProjectBoard(tasks: []);
  bool loading = false;
  String? error;

  ProjectBoardState({ApiClient? api}) : _api = api ?? ApiClient();

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final tasks = await _api.fetchTasks();
      board = ProjectBoard(tasks: tasks);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
