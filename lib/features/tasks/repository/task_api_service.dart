import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../model/task_model.dart';

class TaskApiService {
  final ApiClient _client;

  TaskApiService(this._client);

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

  Map<String, dynamic> _taskBody(Task task, {bool withIsDone = false}) {
    return {
      "title": task.title,
      "priority": priorityToString(task.priority),
      "deadline": task.deadline?.toIso8601String(),
      if (withIsDone) "isDone": task.isDone,
    };
  }

  Future<Map<String, dynamic>> createTask(Task task) {
    return _client.post(ApiConstants.tasksEndpoint, body: _taskBody(task));
  }

  Future<void> updateTask(Task task) {
    return _client.put(
      "${ApiConstants.tasksEndpoint}/${task.id}",
      body: _taskBody(task, withIsDone: true),
    );
  }

  Future<void> deleteTask(String id) {
    return _client.delete("${ApiConstants.tasksEndpoint}/$id");
  }
}
