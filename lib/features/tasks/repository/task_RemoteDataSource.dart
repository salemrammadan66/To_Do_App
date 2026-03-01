import '../model/task_model.dart';
import 'task_api_service.dart';

class TaskRemoteDataSource {
  final TaskApiService api;

  TaskRemoteDataSource(this.api);

  Future<String> create(Task task) async {
    final response = await api.createTask(task);
    return response["id"];
  }

  Future<void> update(Task task) async {
    await api.updateTask(task);
  }

  Future<void> delete(String id) async {
    await api.deleteTask(id);
  }
}