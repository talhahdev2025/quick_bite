import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.darkPrimary,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: AppInsets.xl,
        ),
        child: Text(text),
      ),
    );
  }
}