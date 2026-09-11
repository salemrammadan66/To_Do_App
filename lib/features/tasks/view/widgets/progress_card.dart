import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../Auth/viewmodel/auth_provider.dart';
import '../../viewmodel/prov.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final taskProvider = context.watch<TaskProvider>();

    final completed = taskProvider.completedTasks.length;
    final pending = taskProvider.pendingTasks.length;
    final total = completed + pending;
    final progress = total == 0 ? 0.0 : completed / total;

    final name = authProvider.user?.name.split(" ").first ?? "there";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.floatingBtnColor,
            AppColors.floatingBtnColor.withValues(alpha: 0.65),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${_greeting()}, $name",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.auto_awesome, color: Colors.white),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Let's make today productive.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "$completed / $total",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                "$completed Completed",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.sync_outlined, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                "$pending Remaining",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}