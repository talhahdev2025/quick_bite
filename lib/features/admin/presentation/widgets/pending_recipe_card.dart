import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/admin/presentation/providers/providers.dart';
import 'package:quick_bite/features/admin/presentation/widgets/reject_reason_bottom_sheet.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class PendingRecipeCard extends ConsumerWidget {
  final Recipe recipe;
  final VoidCallback? onViewRecipe;

  const PendingRecipeCard({super.key, required this.recipe, this.onViewRecipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: AppInsets.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row: Recipe Image + Name & Metadata
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.medium,
                  child: recipe.image != null && recipe.image!.isNotEmpty
                      ? Image.network(
                          recipe.image!,
                          width: AppSizes.imageMedium,
                          height: AppSizes.imageMedium,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImagePlaceholder(),
                        )
                      : _buildImagePlaceholder(),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name ?? 'Untitled Recipe',
                        style: const TextStyle(
                          fontSize: AppSizes.lg,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.xs),
                      if (recipe.userId != null)
                        Text(
                          'Submitted by: ${recipe.userId}',
                          style: const TextStyle(
                            fontSize: AppSizes.md - 1,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (recipe.cuisine != null) ...[
                        const SizedBox(height: AppSizes.xs / 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: AppSizes.xs / 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: AppRadius.small,
                          ),
                          child: Text(
                            recipe.cuisine!,
                            style: const TextStyle(
                              fontSize: AppSizes.md - 2,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            // View Recipe Action Button
            OutlinedButton.icon(
              onPressed: onViewRecipe ??
                  () => context.pushNamed(AppRoutes.recipeDetail, extra: recipe),
              icon: const Icon(
                Icons.visibility_outlined,
                size: AppSizes.iconSmall,
              ),
              label: const Text('View Full Recipe'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.divider),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.medium,
                ),
                padding: AppInsets.vSm,
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // Decision Buttons: Reject vs Approve
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final String? rejectReason =
                          await RejectReasonBottomSheet.show(context);
                      if (rejectReason != null && rejectReason.isNotEmpty) {
                        await ref
                            .read(pendingRecipesNotifierProvider.notifier)
                            .rejectRecipe(
                              recipeId: recipe.id!,
                              rejectReason: rejectReason,
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recipe rejected successfully.'),
                            ),
                          );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.medium,
                      ),
                      padding: AppInsets.vSm,
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleApprove(context, ref),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.medium,
                      ),
                      padding: AppInsets.vSm,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: AppSizes.imageMedium,
      height: AppSizes.imageMedium,
      color: AppColors.background,
      child: const Center(
        child: Text('🍛', style: TextStyle(fontSize: AppSizes.iconXLarge)),
      ),
    );
  }

  void _handleApprove(BuildContext context, WidgetRef ref) {
    if (recipe.id == null) return;
    ref.read(pendingRecipesNotifierProvider.notifier).approveRecipe(recipe.id!);
  }
}