import 'package:flutter/widgets.dart';

import 'app_sizes.dart';

class AppInsets {
  AppInsets._();

  // All

  static const EdgeInsets xs = EdgeInsets.all(AppSizes.xs);

  static const EdgeInsets sm = EdgeInsets.all(AppSizes.sm);

  static const EdgeInsets md = EdgeInsets.all(AppSizes.md);

  static const EdgeInsets lg = EdgeInsets.all(AppSizes.lg);

  static const EdgeInsets xl = EdgeInsets.all(AppSizes.xl);

  static const EdgeInsets xxl = EdgeInsets.all(AppSizes.xxl);

  static const EdgeInsets xxxl = EdgeInsets.all(AppSizes.xxxl);

  // Horizontal

  static const EdgeInsets hXs = EdgeInsets.symmetric(horizontal: AppSizes.xs);

  static const EdgeInsets hSm = EdgeInsets.symmetric(horizontal: AppSizes.sm);

  static const EdgeInsets hMd = EdgeInsets.symmetric(horizontal: AppSizes.md);

  static const EdgeInsets hLg = EdgeInsets.symmetric(horizontal: AppSizes.lg);

  static const EdgeInsets hXl = EdgeInsets.symmetric(horizontal: AppSizes.xl);

  static const EdgeInsets hXxl = EdgeInsets.symmetric(horizontal: AppSizes.xxl);

  static const EdgeInsets hXxxl = EdgeInsets.symmetric(
    horizontal: AppSizes.xxxl,
  );

  // Vertical

  static const EdgeInsets vXs = EdgeInsets.symmetric(vertical: AppSizes.xs);

  static const EdgeInsets vSm = EdgeInsets.symmetric(vertical: AppSizes.sm);

  static const EdgeInsets vMd = EdgeInsets.symmetric(vertical: AppSizes.md);

  static const EdgeInsets vLg = EdgeInsets.symmetric(vertical: AppSizes.lg);

  static const EdgeInsets vXl = EdgeInsets.symmetric(vertical: AppSizes.xl);

  static const EdgeInsets vXxl = EdgeInsets.symmetric(vertical: AppSizes.xxl);

  static const EdgeInsets vXxxl = EdgeInsets.symmetric(vertical: AppSizes.xxxl);

  // Individual

  static const EdgeInsets top = EdgeInsets.only(top: AppSizes.lg);

  static const EdgeInsets bottom = EdgeInsets.only(bottom: AppSizes.lg);

  static const EdgeInsets left = EdgeInsets.only(left: AppSizes.lg);

  static const EdgeInsets right = EdgeInsets.only(right: AppSizes.lg);

  // Screen Padding

  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: AppSizes.lg,
    vertical: AppSizes.lg,
  );

  // Card Padding

  static const EdgeInsets card = EdgeInsets.all(AppSizes.lg);

  // Dialog Padding

  static const EdgeInsets dialog = EdgeInsets.all(AppSizes.xxl);

  //button padding
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: AppSizes.lg,
    vertical: AppSizes.md,
  );
  // List Tile Padding

  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: AppSizes.lg,
    vertical: AppSizes.sm,
  );
}
