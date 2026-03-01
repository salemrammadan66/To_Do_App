import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskProvider(this.repository) {
    _loadTasks();
  }

  List<Task> _tasks = [];

  Future<void> _loadTasks() async {
    _tasks = repository.getTasks();
    notifyListeners();
  }

  String _searchQuery = "";
  bool _sortDescending = true;
  bool _hideCompleted = false;

  List<Task> get _allTasks => _tasks;

  List<Task> get _filteredTasks {
    return _allTasks.where((task) {
      final matchesSearch =
      task.title.toLowerCase().contains(_searchQuery.toLowerCase());

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

  List<Task> get pendingTasks =>
      _sortedTasks.where((t) => !t.isDone).toList();

  List<Task> get completedTasks =>
      _sortedTasks.where((t) => t.isDone).toList();

  Future<void> addTask(Task task) async {
    await repository.addTask(task);
    notifyListeners();
  }

  Future<void> toggleTaskDone(Task task) async {
    await repository.toggleTask(task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await repository.deleteTask(task);
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
}