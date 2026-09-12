import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../Auth/view/profile_page.dart';
import '../../settings/view/settings_page.dart';
import 'calendar_page.dart';
import 'home_page.dart';
import 'widgets/bottom_sheet_add_new_todo.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    CalendarPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  void _openAddTodoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bottomSheetBacgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return const BottomsheetAddnewtodo();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        onAddTap: _openAddTodoSheet,
      ),
    );
  }
}