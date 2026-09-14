import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_durations.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/features/favorite/presentation/providers/providers.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteAsync = ref.watch(favoriteNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: AppSizes.xxl,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: favoriteAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async => ref.invalidate(favoriteNotifierProvider),
              child: ListView(children: [_buildEmptyState()]),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () async => ref.invalidate(favoriteNotifierProvider),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                    vertical: AppSizes.lg,
                  ),
                  sliver: SliverList.separated(
                    itemCount: recipes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.md),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Dismissible(
                        key: ValueKey(recipe.id ?? index),
                        direction: DismissDirection.endToStart,
                        background: _buildDismissibleBackground(),
                        onDismissed: (_) {
                          _removeFavorite(context, ref, recipe);
                        },
                        child: _buildFavoriteCard(context, ref, recipe: recipe),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stackTrace) => _buildErrorState(ref),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.15),
        borderRadius: AppRadius.large,
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: AppColors.error,
        size: AppSizes.iconMedium,
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    WidgetRef ref, {
    required Recipe recipe,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.large,
        child: InkWell(
          borderRadius: AppRadius.large,
          onTap: () {
            context.pushNamed(AppRoutes.recipeDetail, extra: recipe);
          },
          child: Padding(
            padding: AppInsets.card,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.medium,
                  child: Image.network(
                    recipe.image ?? '',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null)
                            return child;
                          return Container(
                            width: 64,
                            height: 64,
                            color: AppColors.background,
                          );
                        },
                    errorBuilder: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.fastfood_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${recipe.cookTimeMinutes ?? 0} mins • ${recipe.difficulty ?? 'Easy'}',
                        style: const TextStyle(
                          fontSize: AppSizes.md,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.primary,
                    size: AppSizes.iconMedium,
                  ),
                  onPressed: () => _removeFavorite(context, ref, recipe),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeFavorite(BuildContext context, WidgetRef ref, Recipe recipe) {
    HapticFeedback.lightImpact();

    // Toggle state off
    ref.read(favoriteNotifierProvider.notifier).toggleFavorite(recipe);

    final messenger = ScaffoldMessenger.of(context);

    // Immediately clear any active snackbars to prevent queuing
    messenger.hideCurrentSnackBar();
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        showCloseIcon: true,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Text('${recipe.name ?? "Recipe"} removed from favorites'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: () {
            HapticFeedback.lightImpact();
            // Re-add to favorites without showing another snackbar
            ref.read(favoriteNotifierProvider.notifier).toggleFavorite(recipe);
            messenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: AppInsets.vXxxl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppInsets.lg,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: AppSizes.iconXLarge * 1.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: AppSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'Tap the heart icon on any recipe to save it here.',
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
            'Failed to Load Favorites',
            style: TextStyle(
              fontSize: AppSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'Check your connection and try again.',
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
            onPressed: () => ref.invalidate(favoriteNotifierProvider),
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
