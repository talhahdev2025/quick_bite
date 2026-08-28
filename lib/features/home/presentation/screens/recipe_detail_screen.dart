import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';
import 'package:quick_bite/features/home/presentation/widgets/favorite_icon.dart';
import 'package:quick_bite/features/home/presentation/widgets/recipe_detail_card.dart';
import 'package:quick_bite/features/home/presentation/widgets/info_items.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.data});
  final Recipe data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.screen,
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back),
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
                mainContainerAlignment: .end,
                width: MediaQuery.heightOf(context) * 0.38,
                data: data,
              ),
            ),
            // rating
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.lg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoItem(
                      icon: Icons.star_rounded,
                      value: '${data.rating}',
                      label: '${data.reviewCount} reviews',
                    ),
                    InfoItem(
                      icon: Icons.timer_outlined,
                      value:
                          '${(data.prepTimeMinutes ?? 0) + (data.cookTimeMinutes ?? 0)} min',
                      label: 'Total time',
                    ),
                    InfoItem(
                      icon: Icons.people_outline,
                      value: '${data.servings}',
                      label: 'Servings',
                    ),
                    InfoItem(
                      icon: Icons.local_fire_department_outlined,
                      value: '${data.caloriesPerServing}',
                      label: 'Calories',
                    ),
                  ],
                ),
              ),
            ),
            //ingredients
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ingredients', style: AppTextStyles.headlineMedium),
                    AppSpacing.vSm,
                    Column(
                      spacing: 12.0,
                      children: (data.ingredients ?? []).map((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: .start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: AppSizes.iconLarge,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            //instructions
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Instructions', style: AppTextStyles.headlineMedium),

                    AppSpacing.vSm,

                    ...data.instructions!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final instruction = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
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
            // tags
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.lg,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: data.tags!
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//info item
