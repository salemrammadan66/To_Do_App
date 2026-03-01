import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/task_model.dart';

class TaskApiService {
  final String baseUrl = "https://todo-backend-oob0.onrender.com/api/todos";

  Future<Map<String, dynamic>> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": task.title,
        "priority": task.priority,
        "deadline": task.deadline?.toIso8601String(),
      }),
    );

    return jsonDecode(response.body);
  }

  Future<void> updateTask(Task task) async {
    await http.put(
      Uri.parse("$baseUrl/${task.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": task.title,
        "priority": task.priority,
        "deadline": task.deadline?.toIso8601String(),
        "isDone": task.isDone,
      }),
    );
  }

  Future<void> deleteTask(String id) async {
    await http.delete(
      Uri.parse("$baseUrl/$id"),
    );
  }

  Future<List<dynamic>> getAllTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }
}