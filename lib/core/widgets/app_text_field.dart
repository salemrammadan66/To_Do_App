import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Widget موحّد لكل حقول الإدخال في المشروع.
/// لو بعتّله [validator] بيشتغل كـ TextFormField (للفاليديشن)،
/// لو من غيره بيشتغل كـ TextField عادي.
/// الألوان كلها جايه من AppColors فبتتغير لوحدها مع تبديل الثيم.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool isPassword;
  final bool autofocus;
  final double borderRadius;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final void Function(PointerDownEvent event)? onTapOutside;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isPassword = false,
    this.autofocus = false,
    this.borderRadius = 15,
    this.keyboardType,
    this.focusNode,
    this.inputFormatters,
    this.suffixIcon,
    this.onChanged,
    this.onTapOutside,
    this.validator,
  });

  InputDecoration get _decoration => InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.searchBarColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (validator != null) {
      return TextFormField(
        controller: controller,
        obscureText: isPassword,
        autofocus: autofocus,
        keyboardType: keyboardType,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onTapOutside: onTapOutside,
        cursorColor: AppColors.fontColor,
        style: TextStyle(color: AppColors.fontColor),
        validator: validator,
        decoration: _decoration,
      );
    }

    return TextField(
      controller: controller,
      obscureText: isPassword,
      autofocus: autofocus,
      keyboardType: keyboardType,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      cursorColor: AppColors.fontColor,
      style: TextStyle(color: AppColors.fontColor),
      decoration: _decoration,
    );
  }
}