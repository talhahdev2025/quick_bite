import 'package:flutter/material.dart';
import 'package:quick_bite/constants/app_colors.dart';
import 'package:quick_bite/constants/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'this is home screen',
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
