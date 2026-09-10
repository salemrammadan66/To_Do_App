import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';

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
    return AppTextField(
      controller: controller,
      hintText: hintText,
      isPassword: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }

        if (!isPassword) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return "Enter a valid email";
          }
        }

        if (isPassword) {
          if (value.length < 6) {
            return "Password must be at least 6 characters";
          }
        }

        return null;
      },
    );
  }
}
