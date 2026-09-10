import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_colors.dart';
import '../model/task_model.dart';
import '../viewmodel/prov.dart';
import 'widgets/bottom_sheet_add_new_todo.dart';
import 'widgets/task_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  List<Task> _tasksForDay(DateTime day, List<Task> tasks) {
    return tasks
        .where(
          (t) => t.deadline != null && _dateOnly(t.deadline!) == _dateOnly(day),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final allTasks = taskProvider.allTasks;
        final selectedTasks = _selectedDay == null
            ? <Task>[]
            : _tasksForDay(_selectedDay!, allTasks);

        return Scaffold(
          backgroundColor: AppColors.bodyColor,
          appBar: AppBar(
            backgroundColor: AppColors.bodyColor,
            iconTheme: IconThemeData(color: AppColors.fontColor),
            title: Text(
              "Calendar",
              style: TextStyle(color: AppColors.fontColor),
            ),
          ),
          body: Column(
            children: [
              TableCalendar<Task>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => _tasksForDay(day, allTasks),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.floatingBtnColor.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.floatingBtnColor,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppColors.checkedTaskColor,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: AppColors.fontColor),
                  weekendTextStyle: TextStyle(color: AppColors.fontColor),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: AppColors.fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  formatButtonTextStyle: TextStyle(color: AppColors.fontColor),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: AppColors.floatingBtnColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.fontColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.fontColor,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey),
                  weekendStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: selectedTasks.isEmpty
                    ? Center(
                        child: Text(
                          "No tasks on this day",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: selectedTasks.length,
                        itemBuilder: (context, index) {
                          final task = selectedTasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TaskCard(
                              index: index,
                              title: task.title,
                              priority: task.priority,
                              deadline: task.deadline,
                              isDone: task.isDone,
                              isSynced: task.isSynced,
                              onToggleDone: () {
                                taskProvider.toggleTaskDone(task);
                              },
                              onEdit: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:
                                      AppColors.bottomSheetBacgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  builder: (context) {
                                    return BottomsheetAddnewtodo(
                                      existingTask: task,
                                    );
                                  },
                                );
                              },
                              onDelete: () {
                                taskProvider.deleteTask(task);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
