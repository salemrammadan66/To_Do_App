import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'bottom_sheet_add_new_todo.dart';

class FloatingActionBtn extends StatefulWidget{
  const FloatingActionBtn({super.key});

  @override
  State<FloatingActionBtn> createState() => _FloatingActionBtnState();
}

class _FloatingActionBtnState extends State<FloatingActionBtn>{
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.floatingBtnColor,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.bottomSheetBacgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (context) {
            return BottomsheetAddnewtodo();
          },
        );
      },
      child: Text(
        "+",
        style: TextStyle(
          color: AppColors.fontColor,
          fontSize: 36,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}