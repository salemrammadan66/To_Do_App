import 'package:flutter/material.dart';

import '../../../../Settings/App_Colors.dart';
import '../../model/task_model.dart';
import '../../viewmodel/prov.dart';
import 'package:provider/provider.dart';

class BottomsheetAddnewtodo extends StatefulWidget {
  const BottomsheetAddnewtodo({super.key});

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
                "New To-Do",
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

                  final task = Task(
                    title: controller.text,
                    priority: priority!,
                    deadline: selectedDateTime!,
                    isDone: false,
                    isSynced: false,
                    isDeleted: false,
                    updatedAt: DateTime.now(),
                  );

                  Provider.of<TaskProvider>(
                    context,
                    listen: false,
                  ).addTask(task); // add task

                  setState(() {
                    //empty the fields
                    controller.clear();
                    textFieldIsEmpty = false;
                    priority = null;
                    selectedDateTime = null;
                  });

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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                // Deadline choose Button
                onPressed: () async {
                  FocusScope.of(context).unfocus(); //unfocus and close keyboard

                  final DateTime? pickedDate = await showDatePicker(
                    //pick date
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate == null) return;

                  final TimeOfDay? pickedTime = await showTimePicker(
                    //pick time
                    context: context,
                    initialTime: TimeOfDay.now(),
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
                  Radio<int>(
                    activeColor: AppColors.radioBtnColor,
                    value: 2,
                    groupValue: priority,
                    onChanged: (val) {
                      setState(() {
                        priority = val;
                      });
                    },
                  ),
                  Text("High", style: TextStyle(color: AppColors.fontColor)),
                ],
              ),

              // Medium RB
              Row(
                children: [
                  Radio<int>(
                    activeColor: AppColors.radioBtnColor,
                    value: 1,
                    groupValue: priority,
                    onChanged: (val) {
                      setState(() {
                        priority = val;
                      });
                    },
                  ),
                  Text("Medium", style: TextStyle(color: AppColors.fontColor)),
                ],
              ),

              // Low RB
              Padding(
                padding: const EdgeInsets.only(right: 50.0),
                child: Row(
                  children: [
                    Radio<int>(
                      activeColor: AppColors.radioBtnColor,
                      value: 0,
                      groupValue: priority,
                      onChanged: (val) {
                        setState(() {
                          priority = val;
                        });
                      },
                    ),
                    Text("Low", style: TextStyle(color: AppColors.fontColor)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
