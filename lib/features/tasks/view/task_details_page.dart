import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/cute_avatars.dart';
import '../model/task_model.dart';
import 'widgets/bottom_sheet_add_new_todo.dart';
import 'widgets/delete_task_dialog.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  String _priorityName(int priority) {
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

  String _formatDeadline(DateTime? deadline) {
    if (deadline == null) return "No deadline";
    final h = deadline.hour.toString().padLeft(2, '0');
    final m = deadline.minute.toString().padLeft(2, '0');
    return "${deadline.day}/${deadline.month}/${deadline.year}  •  $h:$m";
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.floatingBtnColor, size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AppColors.fontColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      appBar: AppBar(
        backgroundColor: AppColors.bodyColor,
        iconTheme: IconThemeData(color: AppColors.fontColor),
        title: Text(
          "Task Details",
          style: TextStyle(color: AppColors.fontColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CuteAvatar(data: avatarById(task.avatarId), size: 90),
            ),
            const SizedBox(height: 20),
            Text(
              task.title,
              style: TextStyle(
                color: AppColors.fontColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 20),
            _infoRow(Icons.flag_outlined, "Priority", _priorityName(task.priority)),
            _infoRow(Icons.calendar_today_outlined, "Deadline", _formatDeadline(task.deadline)),
            _infoRow(
              task.isDone ? Icons.check_circle_outline : Icons.pending_actions_outlined,
              "Status",
              task.isDone ? "Completed" : "Pending",
            ),
            _infoRow(
              task.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
              "Sync",
              task.isSynced ? "Synced" : "Not synced yet",
            ),
            const Spacer(),
            AppPrimaryButton(
              text: "Edit Task",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.bottomSheetBacgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return BottomsheetAddnewtodo(existingTask: task);
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: AppTextActionButton(
                text: "Delete Task",
                color: Colors.red,
                onPressed: () async {
                  final deleted = await showDeleteTaskDialog(context, task);
                  if (deleted && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}