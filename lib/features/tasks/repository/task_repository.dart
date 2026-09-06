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

  // All the methods below only touch local storage (fast, no network
  // wait). The caller (TaskProvider) triggers syncPendingTasks() in the
  // background afterwards, so the UI never blocks on the server.

  Future<Task> addTask(Task task) async {
    task.isSynced = false;
    await local.addTask(task);
    return task;
  }

  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
  }

  Future<void> deleteTask(Task task) async {
    task.isDeleted = true;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
  }

  Future<void> editTask(Task task) async {
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await local.saveTask(task);
  }

  /// Pushes every locally pending change (created/updated/deleted while
  /// offline) to the server. Safe to call anytime - e.g. on app start,
  /// automatically when connectivity comes back, or right after a local
  /// change - since each task is handled independently and a failure on
  /// one never blocks the rest.
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
        debugPrint("Sync postponed for task '${task.title}': $e");
      }
    }
  }

  /// Pulls the user's tasks from the server and adds any that aren't
  /// already stored locally (matched by remote id). Safe to call
  /// repeatedly - existing tasks are never duplicated or overwritten.
  Future<void> pullFromServer() async {
    final remoteTasks = await remote.fetchAll();
    final localTasks = local.getAllTasks();
    final knownRemoteIds = localTasks
        .map((t) => t.id)
        .whereType<String>()
        .toSet();

    for (final task in remoteTasks) {
      if (task.id != null && !knownRemoteIds.contains(task.id)) {
        await local.addTask(task);
      }
    }
  }
}
