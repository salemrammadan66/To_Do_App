import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../model/task_model.dart';
import '../../viewmodel/prov.dart';

Future<bool> showDeleteTaskDialog(BuildContext context, Task task) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.bottomSheetBacgroundColor,
      title: Text("Delete task?", style: TextStyle(color: AppColors.fontColor)),
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
            final overlay = Overlay.of(context);
            final navigator = Navigator.of(dialogContext);

            final success = await Provider.of<TaskProvider>(
              context,
              listen: false,
            ).deleteTask(task);

            navigator.pop(success);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAppSnackBar(
                overlay,
                success
                    ? "Task deleted"
                    : "Something went wrong, please try again",
                type: success ? AppToastType.success : AppToastType.error,
                actionLabel: success ? "UNDO" : null,
                onAction: success
                    ? () async {
                  if (!context.mounted) return;
                  final restored = await Provider.of<TaskProvider>(
                    context,
                    listen: false,
                  ).undoDeleteTask(task);
                  if (!context.mounted) return;
                  if (!restored) {
                    showAppSnackBar(
                      Overlay.of(context),
                      "Couldn't undo, task already synced",
                      type: AppToastType.error,
                    );
                  }
                }
                    : null,
              );
            });
          },
        ),
      ],
    ),
  );

  return result ?? false;
}
