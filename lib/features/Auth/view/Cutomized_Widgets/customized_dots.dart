import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CustomizedDots extends StatelessWidget {
  final int currentIndex;
  final int totalDots;

  const CustomizedDots({
    super.key,
    required this.currentIndex,
    required this.totalDots,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? AppColors.floatingBtnColor
                : Colors.white54,
          ),
        );
      }),
    );
  }
}
