import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cute_avatars.dart';

// new_str
class TaskCard extends StatefulWidget {
  final int index;
  final String title;
  final int priority;
  final dynamic deadline;
  final bool isDone;
  final bool isSynced;
  final int avatarId;
  final VoidCallback? onToggleDone;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.index,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.isDone,
    required this.isSynced,
    this.avatarId = 0,
    this.onToggleDone,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  static const List<String> _monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  String _formatDeadline(BuildContext context) {
    final deadline = widget.deadline as DateTime?;
    if (deadline == null) return "No deadline";
    final time = TimeOfDay.fromDateTime(deadline).format(context);
    return "${deadline.day} ${_monthNames[deadline.month - 1]}, $time";
  }

  bool get _isOverdue {
    final deadline = widget.deadline as DateTime?;
    return !widget.isDone &&
        deadline != null &&
        deadline.isBefore(DateTime.now());
  }

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

  Color get _cardColor =>
      AppColors.cardPalette[widget.index % AppColors.cardPalette.length];

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onEdit,
      onLongPress: widget.onDelete,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // new_str
              child: Row(
                children: [
                  CuteAvatar(data: avatarById(widget.avatarId), size: 30),
                  const SizedBox(width: 6),
                  Checkbox(
                    value: widget.isDone,
                    onChanged: (_) => widget.onToggleDone?.call(),
                    activeColor: AppColors.checkedTaskColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.cardTextColor,
                        fontSize: 16,
                        decoration: widget.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.cardTextColor,
                      ),
                    ),
                  ),
                  if (!widget.isSynced)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.cloud_off,
                        size: 16,
                        color: AppColors.cardSubTextColor,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDeadline(context),
                    style: TextStyle(
                      color: _isOverdue
                          ? Colors.redAccent
                          : AppColors.cardSubTextColor,
                      fontSize: 12,
                      fontWeight: _isOverdue
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Text(
                    getPriorityName(widget.priority),
                    style: TextStyle(
                      color: AppColors.cardSubTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
