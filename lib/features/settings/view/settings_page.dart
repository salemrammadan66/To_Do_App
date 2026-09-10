import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final isDark = context.read<ThemeProvider>().isDark;

    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: AppColors.fontColor),
                    ),
                  ),
                  Text(
                    "SETTINGS",
                    style: TextStyle(
                      color: AppColors.fontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dark Mode",
                        style: TextStyle(color: AppColors.fontColor, fontSize: 20),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isDark ? "ON" : "OFF",
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  Switch(
                    value: isDark,
                    activeColor: AppColors.checkedTaskColor,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme(value);
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.grey, height: 30),
            ],
          ),
        ),
      ),
    );
  }
}