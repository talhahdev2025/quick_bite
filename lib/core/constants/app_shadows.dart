import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static final cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 10,
      offset: const Offset(4, 4),
    ),
  ];

  static final buttonShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 12,
      offset: const Offset(0, 5),
    ),
  ];
}
