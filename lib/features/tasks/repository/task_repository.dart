import 'package:flutter/foundation.dart';
import '../model/task_model.dart';
import 'task_local_data_source.dart';
import 'task_remote_data_source.dart';

class TaskRepository {
  final TaskLocalDataSource local;
  final TaskRemoteDataSource remote;

  TaskRepository({required this.local, required this.remote});

  List<Task> getTasks() {
    return local.getAllTasks();
  }

  Future<Task> addTask(Task task) async {
    task.isSynced = false;
    await local.addTask(task);

    try {
      final id = await remote.create(task);
      task.id = id;
      task.isSynced = true;
      await local.saveTask(task);
    } catch (e) {
      // No internet or the server request failed - the task stays saved
      // locally and will sync automatically once connectivity is back.
      debugPrint("Sync postponed for new task (will retry later): $e");
    }

    return task;
  }

  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
    await syncPendingTasks();
  }

  Future<void> editTask(Task task) async {
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
    await syncPendingTasks();
  }

  Future<void> deleteTask(Task task) async {
    task.isDeleted = true;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
    await syncPendingTasks();
  }

  /// Pushes every locally pending change (created/updated/deleted while
  /// offline) to the server. Safe to call anytime - e.g. on app start or
  /// automatically when connectivity comes back - since each task is
  /// handled independently and a failure on one never blocks the rest.
  Future<void> syncPendingTasks() async {
    final unsynced = local.getUnsyncedTasks();

    for (var task in unsynced) {
      try {
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
      } catch (e) {
        // Still offline, or this specific request failed - leave this task
        // pending and keep trying to sync the rest.
        debugPrint("Sync postponed for task '${task.title}': $e");
      }
    }
  }
}
