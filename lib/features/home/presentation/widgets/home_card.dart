import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';
import 'package:quick_bite/features/home/presentation/widgets/favorite_icon.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.data,
    this.bottom,
    this.top,
    this.height,
    this.width,
  });

  final double? bottom;
  final Recipe data;
  final double? top;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.recipeDetail, extra: data);
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Recipe Image Stack
            Stack(
              children: [
                Hero(
                  tag: 'recipe_image_${data.id}',
                  child: Image.network(
                    data.image ?? '',
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 190,
                        color: AppColors.background,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 190,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.broken_image_rounded,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                      );
                    },
                  ),
                ),
                // Bookmark Icon
                Positioned(
                  top: AppSizes.md,
                  right: AppSizes.md,
                  child: Material(
                    color: AppColors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: FavoriteIcon(recipe: data),
                  ),
                ),
                // Cuisine badge if available
                if (data.cuisine != null && data.cuisine!.isNotEmpty)
                  Positioned(
                    top: AppSizes.md,
                    left: AppSizes.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.cuisine!,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Recipe Details (Name, Time, Difficulty)
            Padding(
              padding: AppInsets.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name ?? 'Delicious Recipe',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.onSurfaceMedium,
                      ),
                      AppSpacing.hSm,
                      Text(
                        '${data.cookTimeMinutes ?? 0}m',
                        style: AppTextStyles.bodySmall,
                      ),
                      AppSpacing.hMd,
                      const Text(
                        '·',
                        style: TextStyle(
                          color: AppColors.onSurfaceMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.hMd,
                      const Icon(
                        Icons.local_fire_department_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      AppSpacing.hSm,
                      Text(
                        data.difficulty ?? 'Easy',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (data.rating != null) ...[
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Colors.amber,
                        ),
                        AppSpacing.hSm,
                        Text(
                          data.rating!.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

