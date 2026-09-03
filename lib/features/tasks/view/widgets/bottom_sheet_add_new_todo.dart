import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
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
              MaterialButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.cancelBtnColor),
                ),
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

              MaterialButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: textFieldIsEmpty
                        ? AppColors.saveBtnColor
                        : Colors.grey,
                  ),
                ),
                onPressed: () {
                  if (controller.text.isEmpty ||
                      priority == null ||
                      selectedDateTime == null) {
                    //check fields
                    return;
                  }

                  final taskProvider = Provider.of<TaskProvider>(
                    context,
                    listen: false,
                  );

                  if (isEditing) {
                    // Mutate the existing task in place (same pattern used
                    // by toggleTask/deleteTask) and push the edit.
                    final task = widget.existingTask!;
                    task.title = controller.text;
                    task.priority = priority!;
                    task.deadline = selectedDateTime!;
                    taskProvider.editTask(task);
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
                    taskProvider.addTask(task);
                  }

                  Navigator.pop(context); //close bottomsheet
                },
              ),
            ],
          ),

          // Text Field
          TextField(
            focusNode: textFieldFocus,
            //keyboard issue
            onTapOutside: (event) {
              textFieldFocus.unfocus();
            },
            autofocus: true,
            cursorColor: Colors.white,
            controller: controller,
            onChanged: (val) {
              if (val.isEmpty) {
                setState(() {
                  textFieldIsEmpty = false;
                });
              } else {
                setState(() {
                  textFieldIsEmpty = true;
                });
              }
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "New to-do",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: AppColors.toDoCardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
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
                    );
                    if (pickedDate == null) return;
                    if (!context.mounted) return;

                    final TimeOfDay? pickedTime = await showTimePicker(
                      //pick time
                      context: context,
                      initialTime: selectedDateTime != null
                          ? TimeOfDay.fromDateTime(selectedDateTime!)
                          : TimeOfDay.now(),
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
                    color: Colors.white,
                  ),
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
