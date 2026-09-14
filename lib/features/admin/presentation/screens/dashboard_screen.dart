import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/features/admin/presentation/providers/providers.dart';
import 'package:quick_bite/features/admin/presentation/widgets/pending_recipe_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(pendingRecipesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: AppSizes.xxl,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: recipesAsync.when(
        data: (recipes) {
          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () async {
              ref.invalidate(pendingRecipesNotifierProvider);
            },
            child: ListView(
              padding: AppInsets.screen,
              children: [
                // Summary Header Banner
                _buildSummaryBanner(context, count: recipes.length),
                const SizedBox(height: AppSizes.lg),

                // Section Title
                const Text(
                  'Pending Approval',
                  style: TextStyle(
                    fontSize: AppSizes.xl,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                // Content List or Empty View
                if (recipes.isEmpty)
                  _buildEmptyState()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      return PendingRecipeCard(recipe: recipes[index]);
                    },
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        error: (error, stackTrace) => _buildErrorState(ref),
      ),
    );
  }

  // Header metric card
  Widget _buildSummaryBanner(BuildContext context, {required int count}) {
    return Container(
      padding: AppInsets.card,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: AppInsets.md,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppRadius.medium,
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: AppColors.primary,
              size: AppSizes.iconLarge,
            ),
          ),
          const SizedBox(width: AppSizes.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count ${count == 1 ? 'Recipe' : 'Recipes'} Waiting',
                style: const TextStyle(
                  fontSize: AppSizes.lg,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              const Text(
                'Review and moderate submitted items',
                style: TextStyle(
                  fontSize: AppSizes.md,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Empty Queue View
  Widget _buildEmptyState() {
    return Padding(
      padding: AppInsets.vXxxl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppInsets.lg,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: AppSizes.iconXLarge * 1.5,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const Text(
            'All Caught Up!',
            style: TextStyle(
              fontSize: AppSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'There are no pending recipes requiring review right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.md,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Error Fallback View
  Widget _buildErrorState(WidgetRef ref) {
    return Container(
      padding: AppInsets.screen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: AppSizes.iconXLarge * 1.5,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSizes.md),
          const Text(
            'Failed to Load Recipes',
            style: TextStyle(
              fontSize: AppSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'Check your connection or security permissions.',
            style: TextStyle(
              fontSize: AppSizes.md,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.medium,
              ),
              padding: AppInsets.button,
            ),
            onPressed: () => ref.invalidate(pendingRecipesNotifierProvider),
            icon: const Icon(Icons.refresh, color: AppColors.white),
            label: const Text(
              'Retry',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}