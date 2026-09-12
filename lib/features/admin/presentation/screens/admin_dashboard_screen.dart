import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [TextButton(onPressed: null,child:Text('this is admin dasgboard'))],
        ),
      ),
    );
  }
}
