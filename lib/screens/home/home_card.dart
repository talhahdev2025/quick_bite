import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_shadows.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required this.itemName, required this.imageUrl});
  final String itemName;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 350,
      width: 260,
      margin: AppInsets.card,
      child: Stack(
        alignment: .center,
        clipBehavior: .none,
        children: [
          //main stack container
          Container(
            padding: AppInsets.lg,
            width: 250,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.large,
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                Text(itemName, style: AppTextStyles.headlineMedium),
                AppSpacing.vXxl,
                Text(
                  'N1,900',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          //stacked food image
          Positioned(
            bottom: -50,
            left: 0,
            right: 0,
            top: 60,
            child: Container(
              // clipBehavior: .none,
              padding: AppInsets.xxl,
              decoration: BoxDecoration(
                shape: .circle,
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(-4, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(4, -4),
                  ),
                ],
              ),
              child: Container(
                // clipBehavior: .none,
                padding: AppInsets.card,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.background,
                  image: DecorationImage(image: NetworkImage(imageUrl)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
