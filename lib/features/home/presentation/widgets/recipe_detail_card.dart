import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_shadows.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class RecipeDetailCard extends StatelessWidget {
  const RecipeDetailCard({
    super.key,
    required this.data,
    this.bottom,
    this.top,
    this.height,
    this.width,
    this.mainContainerAlignment = MainAxisAlignment.start,
    this.showDifficulty = false,
  });

  final double? bottom;
  final Recipe data;
  final double? top;
  final double? height;
  final double? width;
  final MainAxisAlignment mainContainerAlignment;
  final bool showDifficulty;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 280.0;

    return Center(
      child: Container(
        height: height ?? 380,
        width: cardWidth,
        margin: AppInsets.card,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Main stack container
            Container(
              padding: AppInsets.lg,
              width: cardWidth - 10,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.large,
                boxShadow: AppShadows.cardShadow,
              ),
              child: Column(
                mainAxisAlignment: mainContainerAlignment,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data.name ?? 'Delicious Recipe',
                    style: AppTextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.vXxl,
                  if (showDifficulty && data.difficulty != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: AppRadius.large,
                        color: AppColors.primary,
                      ),
                      child: Text(
                        data.difficulty!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Stacked food image
            Positioned(
              bottom: bottom ?? -50,
              left: 0,
              right: 0,
              top: top ?? 60,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Hero(
                      tag: 'recipe_image_${data.id}',
                      child: Image.network(
                        data.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood, size: 64, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

