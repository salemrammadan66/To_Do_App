import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_buttons.dart';
import '../viewmodel/prov.dart';
import 'task_details_page.dart';
import 'widgets/bottom_sheet_add_new_todo.dart';
import 'widgets/completed_section_header.dart';
import 'widgets/delete_task_dialog.dart';
import 'widgets/progress_card.dart';
import 'widgets/search_bar_customized.dart';
import 'widgets/task_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  bool isCompletedExpanded = false;

  //bool sortDescending = true; // true = High to Low ---- false = Low to High
  Consumer<TaskProvider> retriveFinishedTasks() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final completedTasks = taskProvider.completedTasks;

        if (completedTasks.isEmpty) return SizedBox(); //check if empty

        return Padding(
          //get data and show
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompletedSectionHeader(
                count: completedTasks.length,
                isExpanded: isCompletedExpanded,
                onTap: () {
                  setState(() {
                    isCompletedExpanded = !isCompletedExpanded;
                  });
                },
              ),
              if (isCompletedExpanded)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    // new_str
                    final task = completedTasks[index];
                    return TaskCard(
                      index: index,
                      avatarId: task.avatarId,
                      title: task.title,
                      priority: task.priority,
                      deadline: task.deadline,
                      isDone: task.isDone,
                      isSynced: task.isSynced,
                      onViewDetails: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TaskDetailsPage(task: task),
                          ),
                        );
                      },
                      onEdit: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.bottomSheetBacgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (context) {
                            return BottomsheetAddnewtodo(existingTask: task);
                          },
                        );
                      },
                      onToggleDone: () {
                        Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        ).toggleTaskDone(task);
                      },
                      onDelete: () => showDeleteTaskDialog(context, task),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Consumer<TaskProvider> retriveUnFinishedTasks() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final pendingTasks = taskProvider.pendingTasks;

        if (pendingTasks.isEmpty) {
          //check if empty
          return Center(
            child: Text(
              "No pending tasks",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          //get data and show
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: pendingTasks.length,
          itemBuilder: (context, index) {
            // new_str
            final task = pendingTasks[index];
            return TaskCard(
              index: index,
              avatarId: task.avatarId,
              title: task.title,
              priority: task.priority,
              deadline: task.deadline,
              isDone: task.isDone,
              isSynced: task.isSynced,
              onViewDetails: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TaskDetailsPage(task: task),
                  ),
                );
              },
              onEdit: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.bottomSheetBacgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) {
                    return BottomsheetAddnewtodo(existingTask: task);
                  },
                );
              },
              onToggleDone: () {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).toggleTaskDone(task);
              },
              onDelete: () => showDeleteTaskDialog(context, task),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.bodyColor,
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () => Provider.of<TaskProvider>(
          context,
          listen: false,
        ).syncPendingTasks(),
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressCard(),
                SizedBox(height: 20),
                SearchbarCustomized(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To-dos",
                          style: TextStyle(
                            color: AppColors.fontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        SizedBox(height: 5),

                        //tasks count
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            return Text(
                              "${taskProvider.pendingTasks.length} to-dos",
                              style: TextStyle(color: Colors.grey),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Sort",
                          style: TextStyle(
                            color: AppColors.fontColor,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //tasks sorting
                            Provider.of<TaskProvider>(
                              context,
                              listen: false,
                            ).toggleSort();
                          },
                          icon: Icon(
                            Icons.sort_by_alpha,
                            color: AppColors.fontColor,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // unfinished
                retriveUnFinishedTasks(),

                //finished
                retriveFinishedTasks(),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
