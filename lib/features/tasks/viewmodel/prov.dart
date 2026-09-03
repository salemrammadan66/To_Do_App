import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/network/network_checker.dart';
import '../model/task_model.dart';
import '../repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;
  StreamSubscription<bool>? _connectivitySubscription;

  TaskProvider(this.repository) {
    _loadTasks();

    // Automatically push any pending offline changes as soon as the
    // connection comes back, instead of waiting for the next manual action.
    _connectivitySubscription = NetworkChecker.onConnectivityChanged.listen((
      isOnline,
    ) {
      if (isOnline) {
        syncPendingTasks();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
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

  List<Task> get pendingTasks => _sortedTasks.where((t) => !t.isDone).toList();

  List<Task> get completedTasks => _sortedTasks.where((t) => t.isDone).toList();

  Future<void> addTask(Task task) async {
    try {
      final newTask = await repository.addTask(task);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding task: $e");
    }
  }

  Future<void> toggleTaskDone(Task task) async {
    try {
      await repository.toggleTask(task);
    } catch (e) {
      debugPrint("Failed to toggle task: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await repository.deleteTask(task);
    } catch (e) {
      debugPrint("Failed to delete task: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Pushes any locally pending (unsynced) changes to the server. Called
  /// automatically when connectivity is restored, but safe to call manually
  /// too (e.g. a pull-to-refresh or a "sync now" button).
  Future<void> syncPendingTasks() async {
    try {
      await repository.syncPendingTasks();
    } catch (e) {
      debugPrint("Sync failed: $e");
    } finally {
      notifyListeners();
    }
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
