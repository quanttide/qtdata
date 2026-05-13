import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quanttide_project/quanttide_project.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({this.baseUrl = 'http://127.0.0.1:8000', http.Client? client})
      : _client = client ?? http.Client();

  Future<List<Task>> fetchTasks() async {
    final resp = await _client.get(Uri.parse('$baseUrl/tasks'));
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch tasks: ${resp.statusCode}');
    }
    final List<dynamic> data = jsonDecode(resp.body);
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Project>> fetchProjects() async {
    final resp = await _client.get(Uri.parse('$baseUrl/projects'));
    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch projects: ${resp.statusCode}');
    }
    final List<dynamic> data = jsonDecode(resp.body);
    return data.map((e) => Project.fromJson(e as Map<String, dynamic>)).toList();
  }

  void dispose() {
    _client.close();
  }
}
