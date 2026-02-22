import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/features/tasks/viewmodel/sync_manager.dart';
import '../model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  late SyncManager _syncManager;

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    _taskBox = Hive.box<Task>('tasksBox');
    _syncManager = SyncManager(_taskBox);
    notifyListeners();
  }

  String _searchQuery = "";
  bool _sortDescending = true;
  bool _hideCompleted = false;

  Future<void> loadTasks() async {
    _taskBox = Hive.box<Task>('tasksBox');
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    task.updatedAt = DateTime.now();
    task.isSynced = false;

    await _taskBox.add(task);
    notifyListeners();

    await _syncManager.sync();
  }

  Future<void> toggleTaskDone(Task task) async {
    task.isDone = !task.isDone;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await task.save();
    notifyListeners();

    await _syncManager.sync();
  }

  Future<void> deleteTask(Task task) async {
    task.isDeleted = true;
    task.isSynced = false;
    task.updatedAt = DateTime.now();

    await task.save();
    notifyListeners();
  }

  void toggleSort() {
    _sortDescending = !_sortDescending;
    notifyListeners();
  }

  void toggleHideCompleted() {
    _hideCompleted = !_hideCompleted;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  // PRIVATE LISTS FOR UI OR ACTIONS ON PUBLIC LISTS
  List<Task> get _filteredTasks {
      return _taskBox.values.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesHide = _hideCompleted ? !task.isDone : true;

      return matchesSearch && matchesHide;
    }).toList();
  }

  List<Task> get _sortedTasks {
    final list = _filteredTasks;

    list.sort(
      (a, b) => _sortDescending
          ? b.priority.compareTo(a.priority)
          : a.priority.compareTo(b.priority),
    );

    return list;
  }

  //PUBLIC LISTS FOR UI
  List<Task> get pendingTasks => _sortedTasks.where((t) => !t.isDone).toList();

  List<Task> get completedTasks => _sortedTasks.where((t) => t.isDone).toList();
}
