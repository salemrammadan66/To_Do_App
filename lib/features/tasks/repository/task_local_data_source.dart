import 'package:hive/hive.dart';

import '../model/task_model.dart';

class TaskLocalDataSource {
  final Box<Task> box;

  TaskLocalDataSource(this.box);

  List<Task> getAllTasks() {
    return box.values.toList();
  }

  Future<void> addTask(Task task) async {
    await box.add(task);
  }

  Future<void> saveTask(Task task) async {
    await task.save();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  List<Task> getUnsyncedTasks() {
    return box.values.where((t) => !t.isSynced).toList();
  }
}