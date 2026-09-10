import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../model/task_model.dart';
import '../../viewmodel/prov.dart';
import 'package:provider/provider.dart';

class BottomsheetAddnewtodo extends StatefulWidget {
  final Task? existingTask;

  const BottomsheetAddnewtodo({super.key, this.existingTask});

  @override
  State<BottomsheetAddnewtodo> createState() => _BottomsheetAddnewtodoState();
}

class _BottomsheetAddnewtodoState extends State<BottomsheetAddnewtodo> {
  DateTime? selectedDateTime;
  bool textFieldIsEmpty = false;
  int? priority;
  TextEditingController controller = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey();

  bool get isEditing => widget.existingTask != null;

  bool get isFormValid =>
      controller.text.trim().isNotEmpty &&
      priority != null &&
      selectedDateTime != null;

  Widget _themedPicker(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppColors.floatingBtnColor,
          onPrimary: Colors.black,
          surface: AppColors.searchBarColor,
          onSurface: AppColors.fontColor,
        ),
        dialogTheme: DialogThemeData(backgroundColor: AppColors.searchBarColor),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.searchBarColor,
          dialBackgroundColor: AppColors.bottomSheetBacgroundColor,
          dialHandColor: AppColors.floatingBtnColor,
          hourMinuteColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.floatingBtnColor
                : AppColors.bottomSheetBacgroundColor,
          ),
          hourMinuteTextColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.black
                : AppColors.fontColor,
          ),
          dayPeriodColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.floatingBtnColor
                : AppColors.bottomSheetBacgroundColor,
          ),
          dayPeriodTextColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.black
                : AppColors.fontColor,
          ),
          dayPeriodBorderSide: BorderSide(color: AppColors.floatingBtnColor),
          entryModeIconColor: AppColors.fontColor,
          helpTextStyle: TextStyle(color: AppColors.fontColor),
        ),
      ),
      child: child!,
    );
  }

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    if (task != null) {
      controller.text = task.title;
      textFieldIsEmpty = task.title.isNotEmpty;
      priority = task.priority;
      selectedDateTime = task.deadline;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // get over the keyboard
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          // cancel & save buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextActionButton(
                text: "Cancel",
                color: AppColors.cancelBtnColor,
                onPressed: () {
                  //close bottomsheet
                  Navigator.pop(context);
                },
              ),
              Text(
                isEditing ? "Edit To-Do" : "New To-Do",
                style: TextStyle(
                  color: AppColors.fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // new_str
              AppTextActionButton(
                text: "Save",
                color: isFormValid ? AppColors.saveBtnColor : Colors.grey,
                onPressed: !isFormValid
                    ? null
                    : () async {
                        final taskProvider = Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        );
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        bool success;
                        String successMessage;

                        if (isEditing) {
                          // Mutate the existing task in place (same pattern
                          // used by toggleTask/deleteTask) and push the edit.
                          final task = widget.existingTask!;
                          task.title = controller.text;
                          task.priority = priority!;
                          task.deadline = selectedDateTime!;
                          success = await taskProvider.editTask(task);
                          successMessage = "Task updated";
                        } else {
                          final task = Task(
                            title: controller.text,
                            priority: priority!,
                            deadline: selectedDateTime!,
                            isDone: false,
                            isSynced: false,
                            isDeleted: false,
                            updatedAt: DateTime.now(),
                          );
                          success = await taskProvider.addTask(task);
                          successMessage = "Task added";
                        }

                        if (!context.mounted) return;

                        navigator.pop(); //close bottomsheet
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? successMessage
                                  : "Something went wrong, please try again",
                            ),
                            backgroundColor: success
                                ? AppColors.checkedTaskColor
                                : Colors.red,
                          ),
                        );
                      },
              ),
            ],
          ),

          // Text Field
          AppTextField(
            focusNode: textFieldFocus,
            //keyboard issue
            onTapOutside: (event) {
              textFieldFocus.unfocus();
            },
            autofocus: true,
            controller: controller,
            hintText: "New to-do",
            borderRadius: 12,
            onChanged: (val) {
              setState(() {
                textFieldIsEmpty = val.isNotEmpty;
              });
            },
          ),

          Text("Choose Priority", style: TextStyle(color: AppColors.fontColor)),

          RadioGroup<int>(
            groupValue: priority,
            onChanged: (val) {
              setState(() {
                priority = val;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      // Deadline choose Button
                      onPressed: () async {
                        FocusScope.of(
                          context,
                        ).unfocus(); //unfocus and close keyboard

                        final DateTime? pickedDate = await showDatePicker(
                          //pick date
                          context: context,
                          initialDate: selectedDateTime ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          builder: _themedPicker,
                        );
                        if (pickedDate == null) return;
                        if (!context.mounted) return;

                        final TimeOfDay? pickedTime = await showTimePicker(
                          //pick time
                          context: context,
                          initialTime: selectedDateTime != null
                              ? TimeOfDay.fromDateTime(selectedDateTime!)
                              : TimeOfDay.now(),
                          builder: _themedPicker,
                        );
                        if (pickedTime == null) return;

                        setState(() {
                          selectedDateTime = DateTime(
                            // save picked date and time
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      },
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        color: AppColors.fontColor,
                      ),
                    ),
                    if (selectedDateTime != null)
                      Text(
                        "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}\n"
                        "${TimeOfDay.fromDateTime(selectedDateTime!).format(context)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.fontColor,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),

                // High RB
                Row(
                  children: [
                    Radio<int>(activeColor: AppColors.radioBtnColor, value: 3),
                    Text("High", style: TextStyle(color: AppColors.fontColor)),
                  ],
                ),

                // Medium RB
                Row(
                  children: [
                    Radio<int>(activeColor: AppColors.radioBtnColor, value: 2),
                    Text(
                      "Medium",
                      style: TextStyle(color: AppColors.fontColor),
                    ),
                  ],
                ),

                // Low RB
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Row(
                    children: [
                      Radio<int>(
                        activeColor: AppColors.radioBtnColor,
                        value: 1,
                      ),
                      Text("Low", style: TextStyle(color: AppColors.fontColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
