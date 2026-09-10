import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  static const String boxName = 'settingsBox';
  static const String key = 'isDark';

  bool get isDark => AppColors.isDark;

  Future<void> toggleTheme(bool value) async {
    AppColors.isDark = value;
    notifyListeners();

    final box = Hive.isBoxOpen(boxName)
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    await box.put(key, value);
  }
}