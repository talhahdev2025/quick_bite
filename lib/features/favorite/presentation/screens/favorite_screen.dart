import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_durations.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/favorite/presentation/providers/providers.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(favoriteNotifierProvider);
            await ref.read(favoriteNotifierProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: AppInsets.screen,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Favorites',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref.invalidate(favoriteNotifierProvider),
                        icon: const Icon(Icons.refresh_rounded),
                        tooltip: 'Refresh Favorites',
                      ),
                    ],
                  ),
                ),
              ),
              favoriteState.when(
                data: (favorites) {
                  if (favorites.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 72,
                              color: AppColors.textHint,
                            ),
                            AppSpacing.vLg,
                            Text(
                              'No favorites yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            AppSpacing.vSm,
                            Text(
                              'Tap the heart icon on any recipe to save it here!',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    sliver: SliverList.separated(
                      itemCount: favorites.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final recipe = favorites[index];
                        return Dismissible(
                          key: Key('fav_${recipe.id ?? index}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: AppRadius.large,
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) {
                            ref
                                .read(favoriteNotifierProvider.notifier)
                                .toggleFavorite(recipe);

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                showCloseIcon: true,
                                duration: AppDurations.normal,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  '${recipe.name ?? "Recipe"} removed from favorites',
                                ),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  textColor: AppColors.primary,
                                  onPressed: () => ref
                                      .read(favoriteNotifierProvider.notifier)
                                      .toggleFavorite(recipe),
                                ),
                              ),
                            );
                          },
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.recipeDetail,
                                extra: recipe,
                              );
                            },
                            borderRadius: AppRadius.large,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadius.large,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      recipe.image ?? '',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        width: 70,
                                        height: 70,
                                        color: AppColors.background,
                                        child: const Icon(
                                          Icons.fastfood,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.name ?? 'Delicious Recipe',
                                          style: AppTextStyles.titleMedium.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AppSpacing.vXs,
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: AppColors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${recipe.cookTimeMinutes ?? 0}m',
                                              style: AppTextStyles.bodySmall,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              recipe.difficulty ?? 'Easy',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite_rounded,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(favoriteNotifierProvider.notifier)
                                          .toggleFavorite(recipe);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (error, stackTrace) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: AppInsets.lg,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 48,
                          ),
                          AppSpacing.vMd,
                          Text(
                            'Failed to load favorites: $error',
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.vMd,
                          ElevatedButton(
                            onPressed: () =>
                                ref.invalidate(favoriteNotifierProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

