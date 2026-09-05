import 'package:flutter/material.dart';

class CompletedSectionHeader extends StatelessWidget {
  final int count;
  final bool isExpanded;
  final VoidCallback onTap;

  const CompletedSectionHeader({
    super.key,
    required this.count,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              'Completed ($count)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}