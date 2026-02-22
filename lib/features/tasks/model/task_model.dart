import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime? deadline;

  @HiveField(2)
  int priority;

  @HiveField(3)
  bool isDone;

  @HiveField(4)
  String? id;

  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  bool isDeleted;

  @HiveField(7)
  DateTime updatedAt;

  Task({
    this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
    this.isSynced = false,
    this.isDeleted = false,
    required this.updatedAt,
  });
}
