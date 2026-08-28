import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        height: height ?? 300, // Adjust height based on content
        width: width ?? 340, // Adjust width
        margin: AppInsets.card,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recipe Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                      16.0,
                    ), // Use appropriate value from AppRadius
                  ),
                  child: Image.network(
                    data.image ?? '',
                    height: 180, // Fixed height for image area
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: AppColors.background,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
                // Bookmark Icon
                Positioned(
                  top: AppSizes.md,
                  right: AppSizes.md,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70, // Semi-transparent white

                    child: FavoriteIcon(recipe: data),
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
                    data.name ?? 'Missing Name',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.vMd,
                  Row(
                    children: [
                      // Time
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.onSurfaceMedium,
                      ),
                      AppSpacing.hSm,
                      Text(
                        '${data.cookTimeMinutes ?? 0}m', // Assuming duration is in minutes
                        style: AppTextStyles.bodySmall,
                      ),
                      AppSpacing.hMd,
                      // Separator Dot
                      const Text(
                        '·',
                        style: TextStyle(color: AppColors.onSurfaceMedium),
                      ),
                      AppSpacing.hMd,
                      // Difficulty
                      Text(
                        '${data.difficulty}',
                        style: AppTextStyles.bodySmall,
                      ),
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
