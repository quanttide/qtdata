import 'package:flutter/foundation.dart';
import 'package:quanttide_project/quanttide_project.dart';
import '../data_board.dart';
import '../services/api_client.dart';

class DataBoardState extends ChangeNotifier {
  final ApiClient _api;

  DataBoard board = DataBoard(tasks: []);
  bool loading = false;
  String? error;

  DataBoardState({ApiClient? api}) : _api = api ?? ApiClient();

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final tasks = await _api.fetchTasks();
      board = DataBoard(tasks: tasks);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
