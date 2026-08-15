import 'package:flutter/material.dart';
import 'package:quick_bite/core/routes/app_router.dart';
import 'package:quick_bite/screens/home/home_screen.dart';
import 'package:quick_bite/screens/splash/splash_screen.dart';

class QuickBite extends StatelessWidget {
  const QuickBite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.routes,
    );
  }
}
