import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_durations.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/favorite/presentation/providers/providers.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppInsets.hXl,
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Favorites', style: AppTextStyles.headlineLarge),
                    IconButton(
                      onPressed: () =>
                          ref.read(favoriteNotifierProvider.notifier).build(),
                      icon: Icon(Icons.refresh_rounded),
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
                            Icons.favorite_border,
                            size: 64,
                            color: AppColors.grey,
                          ),
                          AppSpacing.vLg,
                          Text(
                            'No favorites added yet!',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: AppInsets.screen,
                  sliver: SliverList.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final recipe = favorites[index];
                      return Dismissible(
                        key: Key(recipe.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: AppColors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          // Toggle favorite removes it from SQLite & updates UI state
                          ref
                              .read(favoriteNotifierProvider.notifier)
                              .toggleFavorite(recipe);

                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              duration: AppDurations.normal,
                              behavior: .floating,
                              content: Text(
                                '${recipe.name} removed from favorites',
                              ),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () => ref
                                    .read(favoriteNotifierProvider.notifier)
                                    .toggleFavorite(recipe),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            // horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(
                                recipe.image.toString(),
                              ),
                              onForegroundImageError: (_, _) =>
                                  const Icon(Icons.fastfood, size: 40),
                            ),
                            title: Text(
                              recipe.name!,
                              style: AppTextStyles.bodyLarge,
                            ),
                            // subtitle: Text('\$${recipe..toStringAsFixed(2)}'),
                            // trailing: IconButton(
                            //   icon: const Icon(Icons.favorite, color: Colors.red),
                            //   onPressed: () {
                            //     ref
                            //         .read(favoriteNotifierProvider.notifier)
                            //         .toggleFavorite(recipe);
                            //   },
                            // ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
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
    );
  }
}
