import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Settings/App_Colors.dart';

import '../viewmodel/prov.dart';
import 'Customized_Widgets/Floating_Action_BTN.dart';
import 'Customized_Widgets/PopupMenuItem_Customized.dart';
import 'Customized_Widgets/SearchBar_Customized.dart';
import 'Customized_Widgets/Task_Card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
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
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Completed (${completedTasks.length})",
                style: TextStyle(color: Colors.grey),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  final task = completedTasks[index];
                  return TaskCard(
                    title: task.title,
                    priority: task.priority,
                    deadline: task.deadline,
                    isDone: task.isDone,
                    onToggleDone: () {
                      Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      ).toggleTaskDone(task);
                    },
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
            final task = pendingTasks[index];
            return TaskCard(
              title: task.title,
              priority: task.priority,
              deadline: task.deadline,
              isDone: task.isDone,
              onToggleDone: () {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).toggleTaskDone(task);
              },
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
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
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<TaskProvider>(
                            context,
                            listen: false,
                          ).deleteTask(task);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBtn(),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appBarColor,
        actions: [
          PopupmenuitemCustomized(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                          color: Colors.white,
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
    );
  }
}
