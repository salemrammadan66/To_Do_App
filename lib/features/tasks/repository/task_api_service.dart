import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../model/task_model.dart';

class TaskApiService {
  final ApiClient _client;

  TaskApiService(this._client);

  Future<Map<String, dynamic>> createTask(Task task) {
    return _client.post(
      ApiConstants.tasksEndpoint,
      body: {"title": task.title},
    );
  }

  Future<void> updateTask(Task task) {
    return _client.put(
      "${ApiConstants.tasksEndpoint}/${task.id}",
      body: {"title": task.title, "completed": task.isDone},
    );
  }

  Future<void> deleteTask(String id) {
    return _client.delete("${ApiConstants.tasksEndpoint}/$id");
  }

  Future<List<dynamic>> getTasks() {
    return _client.getList(ApiConstants.tasksEndpoint);
  }
}