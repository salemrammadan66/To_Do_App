import 'package:flutter/material.dart';

class AppColors {
  // Current theme mode flag — flipped by ThemeProvider
  static bool isDark = false;

  static const Color _appBarColorDark = Color(0xFF161616);
  static const Color _bodyColorDark = Color(0xFF161616);
  static const Color _fontColorDark = Color(0xFFffffff);
  static const Color _bottomSheetBacgroundColorDark = Color(0xFF1f1f1f);
  static const Color _searchBarColorDark = Color(0xFF2f2f2f);

  static const Color _appBarColorLight = Color(0xFFFFFFFF);
  static const Color _bodyColorLight = Color(0xFFF7F5F2);
  static const Color _fontColorLight = Color(0xFF1A1A1A);
  static const Color _bottomSheetBacgroundColorLight = Color(0xFFFFFFFF);
  static const Color _searchBarColorLight = Color(0xFFEDE7DD);

  static Color get appBarColor => isDark ? _appBarColorDark : _appBarColorLight;

  static Color get bodyColor => isDark ? _bodyColorDark : _bodyColorLight;

  static Color get fontColor => isDark ? _fontColorDark : _fontColorLight;

  static Color get bottomSheetBacgroundColor =>
      isDark ? _bottomSheetBacgroundColorDark : _bottomSheetBacgroundColorLight;

  static Color get searchBarColor =>
      isDark ? _searchBarColorDark : _searchBarColorLight;

  static const Color checkColor = Color(0xFFdfa20c);
  static const Color floatingBtnColor = Color(0xFFe6a200);
  static const Color checkedTaskColor = Color(0xFFe6a200);
  static const Color cancelBtnColor = Color(0xFFe6a200);
  static const Color saveBtnColor = Color(0xFFe6a200);
  static const Color radioBtnColor = Color(0xFFe6a200);

  static const Color toDoCardColor = Color(0xFF2f2f2f);

  static const List<Color> cardPalette = [
    Color(0xFFF0EBE3),
    Color(0xFFF7EFC0),
    Color(0xFFE8E1D8),
  ];

  static const Color cardTextColor = Color(0xFF3A3A3A);
  static const Color cardSubTextColor = Color(0xFF8A8A8A);
}
