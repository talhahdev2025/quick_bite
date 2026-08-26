import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/features/favorite/presentation/providers/providers.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class FavoriteIcon extends ConsumerWidget {
  const FavoriteIcon({super.key, required this.recipe});
  // final int id;
  final Recipe recipe;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteNotifier = ref.watch(favoriteNotifierProvider);
    final bool isFavorite = favoriteNotifier.maybeWhen(
      data: (data) => data.any((element) => element.id == recipe.id),
      orElse: () => false,
    );
    return IconButton(
      onPressed: () =>
          ref.read(favoriteNotifierProvider.notifier).toggleFavorite(recipe),
      icon: Icon(
        Icons.favorite_border_outlined,
        color: isFavorite ? AppColors.primary : null,
      ),
    );
  }
}
