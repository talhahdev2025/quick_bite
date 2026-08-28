import 'package:flutter/material.dart';

class AppColors {
  AppColors._init();

  // Primary & Accent Colors
  static const Color primary = Color(0xFFFF4B3A);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color darkPrimary = Color(0xFFC03536);

  // Surface & Background Colors
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF111827); // Added for text/icons on surface

  // Status & Feedback Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Typography & Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color onSurfaceMedium = Color(0xFF6B7280); // Added for medium emphasis text/icons (time, dot, difficulty)
  static const Color textHint = Color(0xFF9CA3AF);

  // Card & Overlay Colors
  static const Color overlayLight = Color(0xB3FFFFFF); // Added for bookmark button background (white with ~70% opacity)

  // UI Elements & Utility Colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.grey;
}