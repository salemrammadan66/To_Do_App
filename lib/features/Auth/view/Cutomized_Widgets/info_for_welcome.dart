import 'package:flutter/material.dart';
import 'customized_dots.dart';
import 'scrollable_info.dart';

class InfoForWelcome extends StatefulWidget {
  const InfoForWelcome({super.key});

  @override
  State<InfoForWelcome> createState() => _InfoForWelcomeState();
}

class _InfoForWelcomeState extends State<InfoForWelcome> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "icon": Icons.today,
      "title": "Organize Your Tasks",
      "description":
          "Keep track of all your tasks in one place\nand stay productive every day!",
    },
    {
      "icon": Icons.alarm,
      "title": "Set Reminders",
      "description": "Never miss a task again\nGet reminders on time.",
    },
    {
      "icon": Icons.check_circle,
      "title": "Achieve Goals",
      "description": "Complete your daily goals\nand improve your life.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = pages[index];

              return ScrollableInfo(
                icon: page["icon"],
                title: page["title"],
                description: page["description"],
              );
            },
          ),
        ),

        CustomizedDots(currentIndex: currentPage, totalDots: pages.length),

        const SizedBox(height: 150),
      ],
    );
  }
}
