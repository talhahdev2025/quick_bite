import 'package:flutter/material.dart';
import 'package:quick_bite/core/router/app_router.dart';

class QuickBite extends StatelessWidget {
  const QuickBite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.routes,
    );
  }
}
