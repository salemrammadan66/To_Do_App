import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 50,
    this.borderRadius = 15,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.floatingBtnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black,
          ),
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final double height;
  final double borderRadius;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = true,
    this.height = 50,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.fontColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(text, style: TextStyle(color: AppColors.fontColor)),
      ),
    );
  }
}

class AppTextActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const AppTextActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: color ?? AppColors.fontColor),
      ),
    );
  }
}