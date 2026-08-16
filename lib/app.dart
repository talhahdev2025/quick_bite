import 'package:flutter/material.dart';
import 'package:quick_bite/core/routes/app_router.dart';

class QuickBite extends StatelessWidget {
  const QuickBite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.routes,
    );
  }
}
