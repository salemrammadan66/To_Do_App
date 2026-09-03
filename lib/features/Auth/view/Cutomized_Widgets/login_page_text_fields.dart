import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class LoginPageTextfields extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const LoginPageTextfields({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }

        if (!isPassword) {
          // email validation
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

          if (!emailRegex.hasMatch(value)) {
            return "Enter a valid email";
          }
        }

        if (isPassword) {
          // pass validation
          if (value.length < 6) {
            return "Password must be at least 6 characters";
          }
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.toDoCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
