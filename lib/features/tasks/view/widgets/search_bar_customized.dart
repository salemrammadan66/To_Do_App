import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/prov.dart';

class SearchbarCustomized extends StatefulWidget{
  const SearchbarCustomized({super.key});

  @override
  State<SearchbarCustomized> createState() => _SearchbarCustomized();
}

class _SearchbarCustomized extends State<SearchbarCustomized>{
  TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      controller: controller,
      onChanged: (val) {
        Provider.of<TaskProvider>(
          context,
          listen: false,
        ).setSearchQuery(val);
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
            Provider.of<TaskProvider>(
              context,
              listen: false,
            ).setSearchQuery("");
          },
          icon: Icon(Icons.close, color: Colors.white),
        ),
        hintText: "Search your to-dos",
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.toDoCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}