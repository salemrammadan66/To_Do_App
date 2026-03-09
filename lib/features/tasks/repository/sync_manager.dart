import 'package:hive/hive.dart';
import '../model/task_model.dart';
import 'task_api_service.dart';
class SyncManager {
  final Box<Task> box;
  final TaskApiService api;
  final String token;

  SyncManager(this.box, this.api, this.token);

  Future<void> sync() async {
    final unsynced =
    box.values.where((task) => task.isSynced == false).toList();

    for (var task in unsynced) {
      if (task.isDeleted) {
        if (task.id != null) {
          await api.deleteTask(task.id!);
        }
        await task.delete();
      } else if (task.id == null) {
        final response = await api.createTask(task);

        task.id = response["id"];
        task.isSynced = true;
        await task.save();
      } else {
        await api.updateTask(task);

        task.isSynced = true;
        await task.save();
      }
    }
  }
}