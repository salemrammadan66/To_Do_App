import '../model/task_model.dart';
import 'task_api_service.dart';

class TaskRemoteDataSource {
  final TaskApiService api;

  TaskRemoteDataSource(this.api);

  Future<String> create(Task task) async {
    final response = await api.createTask(task);
    if (response["_id"] == null) {
      throw Exception("Task creation failed: ${response["error"]}");
    }
    return response["_id"];
  }

  Future<void> update(Task task) async => await api.updateTask(task);
  Future<void> delete(String id) async => await api.deleteTask(id);

  /// Fetches all of the logged-in user's tasks from the server. Since the
  /// backend only stores title/completed, priority defaults to Low and
  /// deadline comes back empty - that data never existed server-side.
  Future<List<Task>> fetchAll() async {
    final list = await api.getTasks();

    return list.map((json) {
      final map = json as Map<String, dynamic>;
      return Task(
        id: map['_id'] as String?,
        title: map['title'] as String? ?? '',
        priority: 1, // Low - the backend doesn't track priority
        deadline: null, // the backend doesn't track a deadline either
        isDone: map['completed'] as bool? ?? false,
        isSynced: true,
        isDeleted: false,
        updatedAt:
        DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );
    }).toList();
  }
}