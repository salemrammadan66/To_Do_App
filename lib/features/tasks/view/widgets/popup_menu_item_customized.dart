import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/prov.dart';

class PopupmenuitemCustomized extends StatefulWidget{
  const PopupmenuitemCustomized({super.key});

  State<PopupmenuitemCustomized> createState() => _PopupmenuitemCustomizedState();
}

class _PopupmenuitemCustomizedState extends State<PopupmenuitemCustomized>{
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      menuPadding: EdgeInsets.all(15),
      style: ButtonStyle(alignment: Alignment.centerLeft),
      iconColor: Colors.white,
      color: AppColors.toDoCardColor,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(
            "Edit",
            style: TextStyle(color: AppColors.fontColor),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            context.read<TaskProvider>().toggleHideCompleted();
          },
          child: Text(
            "Hide completed",
            style: TextStyle(color: AppColors.fontColor),
          ),
        ),
      ],
    );
  }
}