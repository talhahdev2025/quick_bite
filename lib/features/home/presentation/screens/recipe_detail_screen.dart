import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';
import 'package:quick_bite/features/home/presentation/widgets/favorite_icon.dart';
import 'package:quick_bite/features/home/presentation/widgets/info_items.dart';
import 'package:quick_bite/features/home/presentation/widgets/recipe_detail_card.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.data});

  final Recipe data;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth * 0.85).clamp(280.0, 480.0);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppInsets.screen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        FavoriteIcon(recipe: data),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: RecipeDetailCard(
                    showDifficulty: true,
                    top: -30,
                    bottom: 150,
                    height: 450,
                    mainContainerAlignment: MainAxisAlignment.end,
                    width: cardWidth,
                    data: data,
                  ),
                ),
                // Rating & Quick stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppInsets.lg,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InfoItem(
                            icon: Icons.star_rounded,
                            value: '${data.rating ?? 4.5}',
                            label: '${data.reviewCount ?? 0} reviews',
                          ),
                          InfoItem(
                            icon: Icons.timer_outlined,
                            value:
                                '${(data.prepTimeMinutes ?? 0) + (data.cookTimeMinutes ?? 0)} min',
                            label: 'Total time',
                          ),
                          InfoItem(
                            icon: Icons.people_outline,
                            value: '${data.servings ?? 2}',
                            label: 'Servings',
                          ),
                          InfoItem(
                            icon: Icons.local_fire_department_outlined,
                            value: '${data.caloriesPerServing ?? 350}',
                            label: 'Calories',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Ingredients
                if (data.ingredients != null && data.ingredients!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppInsets.lg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ingredients', style: AppTextStyles.headlineMedium),
                          AppSpacing.vMd,
                          ...data.ingredients!.map((ingredient) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: AppSizes.iconLarge,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      ingredient,
                                      style: AppTextStyles.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                // Instructions
                if (data.instructions != null && data.instructions!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppInsets.lg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Instructions', style: AppTextStyles.headlineMedium),
                          AppSpacing.vMd,
                          ...data.instructions!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final instruction = entry.value;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.primary,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      instruction,
                                      style: AppTextStyles.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                // Tags
                if (data.tags != null && data.tags!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppInsets.lg,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: data.tags!
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: AppColors.background,
                                  side: BorderSide.none,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//info item
