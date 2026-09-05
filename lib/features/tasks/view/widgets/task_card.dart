import 'package:flutter/material.dart';
import 'package:to_do_app/core/theme/app_colors.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final int priority;
  final dynamic deadline;
  final bool isDone;
  final bool isSynced;
  final VoidCallback? onToggleDone;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.isDone,
    required this.isSynced,
    this.onToggleDone,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String getPriorityName(int priority) {
    //set priority name for show
    switch (priority) {
      case 3:
        return "High";
      case 2:
        return "Medium";
      case 1:
        return "Low";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onEdit,
      onLongPress: widget.onDelete,
      child: Card(
        elevation: 5,
        color: AppColors.toDoCardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  //done button
                  onPressed: widget.onToggleDone,
                  icon: Icon(
                    widget.isDone ? Icons.check_circle : Icons.circle_outlined,
                    color: widget.isDone
                        ? AppColors.checkedTaskColor
                        : Colors.grey,
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(color: AppColors.fontColor, fontSize: 16),
                ),
                if (!widget.isSynced)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(Icons.cloud_off, size: 16, color: Colors.grey),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Text(
                    "${widget.deadline.day}/${widget.deadline.month}/${widget.deadline.year}", //deadline date
                    style: TextStyle(color: AppColors.fontColor),
                  ),
                  Text(
                    getPriorityName(widget.priority),
                    style: TextStyle(color: AppColors.fontColor),
                  ), //priority
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
