import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../viewmodel/prov.dart';

class SearchbarCustomized extends StatefulWidget {
  const SearchbarCustomized({super.key});

  @override
  State<SearchbarCustomized> createState() => _SearchbarCustomized();
}

class _SearchbarCustomized extends State<SearchbarCustomized> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return AppTextField(
      controller: controller,
      hintText: "Search your to-dos",
      borderRadius: 30,
      onChanged: (val) {
        Provider.of<TaskProvider>(context, listen: false).setSearchQuery(val);
      },
      suffixIcon: IconButton(
        onPressed: () {
          controller.clear();
          Provider.of<TaskProvider>(context, listen: false).setSearchQuery("");
        },
        icon: Icon(Icons.close, color: AppColors.fontColor),
      ),
    );
  }
}
