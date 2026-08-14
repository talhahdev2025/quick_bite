import 'package:flutter/material.dart';
import 'package:quick_bite/app.dart';
import 'package:quick_bite/constants/app_colors.dart';
import 'package:quick_bite/constants/app_durations.dart';
import 'package:quick_bite/constants/app_text_styles.dart';
import 'package:quick_bite/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      AppDurations.splash,
      () => setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'this is splah screen',
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
