import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/network/network_checker.dart';
import '../../../core/notifications/notification_service.dart';
import '../model/task_model.dart';
import '../repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;
  StreamSubscription<bool>? _connectivitySubscription;

  TaskProvider(this.repository) {
    _loadTasks();
    pullFromServer();

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

      return matchesSearch && matchesHide && !task.isDeleted;
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

  Future<bool> addTask(Task task) async {
    try {
      final newTask = await repository.addTask(task);
      _tasks.add(newTask);
      notifyListeners();
      syncPendingTasks();
      _updateReminderFor(newTask);
      return true;
    } catch (e) {
      debugPrint("Error adding task: $e");
      return false;
    }
  }

  Future<void> toggleTaskDone(Task task) async {
    try {
      await repository.toggleTask(task);
      _updateReminderFor(task);
    } catch (e) {
      debugPrint("Failed to toggle task: $e");
    } finally {
      notifyListeners();
      syncPendingTasks();
    }
  }

  Future<bool> deleteTask(Task task) async {
    try {
      await repository.deleteTask(task);
      _updateReminderFor(task);
      _tasks.remove(task);
      return true;
    } catch (e) {
      debugPrint("Failed to delete task: $e");
      return false;
    } finally {
      notifyListeners();
      syncPendingTasks();
    }
  }

  Future<bool> editTask(Task task) async {
    try {
      await repository.editTask(task);
      _updateReminderFor(task);
      return true;
    } catch (e) {
      debugPrint("Failed to edit task: $e");
      return false;
    } finally {
      notifyListeners();
      syncPendingTasks();
    }
  }

  Future<void> syncPendingTasks() async {
    try {
      await repository.syncPendingTasks();
    } catch (e) {
      debugPrint("Sync failed: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> pullFromServer() async {
    try {
      await repository.pullFromServer();
      _tasks = repository.getTasks();
    } catch (e) {
      debugPrint("Pull from server failed: $e");
    } finally {
      notifyListeners();
    }
  }

  List<Task> get allTasks => _tasks.where((t) => !t.isDeleted).toList();

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

  void _updateReminderFor(Task task) {
    final id = task.key as int?;
    if (id == null) return;

    if (task.isDeleted || task.isDone || task.deadline == null) {
      NotificationService.cancelTaskReminder(id);
    } else {
      NotificationService.scheduleTaskReminder(
        id: id,
        title: task.title,
        deadline: task.deadline!,
      );
    }
  }
}
