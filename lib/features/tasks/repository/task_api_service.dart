import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/task_model.dart';

class TaskApiService {
  final String baseUrl = "https://todo-backend-oob0.onrender.com/api/todos";
  String? token;

  void setToken(String tokenValue) {
    token = tokenValue;
  }

  String priorityToString(int priority) {
    switch (priority) {
      case 3:
        return "high";
      case 2:
        return "medium";
      case 1:
        return "low";
      default:
        return "low";
    }
  }

  Future<Map<String, dynamic>> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": task.title,
        "priority": priorityToString(task.priority),
        "deadline": task.deadline?.toIso8601String(),
      }),
    );

    return jsonDecode(response.body);
  }

  Future<void> updateTask(Task task) async {
    await http.put(
      Uri.parse("$baseUrl/${task.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": task.title,
        "priority": priorityToString(task.priority),
        "deadline": task.deadline?.toIso8601String(),
        "isDone": task.isDone,
      }),
    );
  }

  Future<void> deleteTask(String id) async {
    await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}