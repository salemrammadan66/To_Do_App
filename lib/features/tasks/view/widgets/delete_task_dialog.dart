import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../model/task_model.dart';
import '../../viewmodel/prov.dart';



Future<bool> showDeleteTaskDialog(BuildContext context, Task task) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.toDoCardColor,
      title: Text(
        "Delete task?",
        style: TextStyle(color: AppColors.fontColor),
      ),
      content: Text(
        "Are you sure you want to delete this task?",
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        AppTextActionButton(
          text: "Cancel",
          color: AppColors.fontColor,
          onPressed: () => Navigator.pop(dialogContext, false),
        ),
        AppTextActionButton(
          text: "Delete",
          color: Colors.red,
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(dialogContext);

            final success = await Provider.of<TaskProvider>(
              context,
              listen: false,
            ).deleteTask(task);

            navigator.pop(success);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? "Task deleted"
                        : "Something went wrong, please try again",
                  ),
                  backgroundColor: success
                      ? AppColors.checkedTaskColor
                      : Colors.red,
                ),
              );
            });
          },
        ),
      ],
    ),
  );

  return result ?? false;
}