import 'package:to_do_app/features/tasks/repository/task_RemoteDataSource.dart';
import 'package:to_do_app/features/tasks/repository/task_localDataSource.dart';

import '../model/task_model.dart';

class TaskRepository {
  final TaskLocalDataSource local;
  final TaskRemoteDataSource remote;

  TaskRepository({
    required this.local,
    required this.remote,
  });

  List<Task> getTasks() {
    return local.getAllTasks();
  }

  Future<void> addTask(Task task) async {
    task.updatedAt = DateTime.now();
    task.isSynced = false;

    await local.addTask(task);
    await _sync();
  }

  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
    await _sync();
  }

  Future<void> deleteTask(Task task) async {
    task.isDeleted = true;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
  }

  Future<void> _sync() async {
    final unsynced = local.getUnsyncedTasks();

    for (var task in unsynced) {
      if (task.isDeleted) {
        if (task.id != null) {
          await remote.delete(task.id!);
        }
        await local.deleteTask(task);
      } else if (task.id == null) {
        final id = await remote.create(task);
        task.id = id;
        task.isSynced = true;
        await local.saveTask(task);
      } else {
        await remote.update(task);
        task.isSynced = true;
        await local.saveTask(task);
      }
    }
  }
}