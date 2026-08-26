import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/database/app_database.dart';
import 'package:quick_bite/features/favorite/data/datasources/recipe_local_data_source.dart';
import 'package:quick_bite/features/favorite/data/repositories/favorite_recipe_repository.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class FavoriteNotifier extends AsyncNotifier<List<Recipe>> {
  @override
  FutureOr<List<Recipe>> build() {
    return _fetchFavorites();
  }

  Future<List<Recipe>> _fetchFavorites() {
    return ref.read(favoriteRecipeRepositoryProvider).getFavorites();
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final favoriteRepo = ref.read(favoriteRecipeRepositoryProvider);
    //TODO: dont use null assertion opertor ! here
    final isFavorite = await favoriteRepo.isFavorite(recipe.id!);
    if (isFavorite) {
      //TODO: dont use null asserstion operator here
      favoriteRepo.removeFavorite(recipe.id!);
    } else {
      favoriteRepo.addFavorite(recipe);
    }
    state = await AsyncValue.guard(() => _fetchFavorites());
  }
}

//providers
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final recipeLocalDataSourceProvider = Provider<RecipeLocalDataSource>(
  (ref) => RecipeLocalDataSource(appDatabase: ref.watch(databaseProvider)),
);

final favoriteRecipeRepositoryProvider = Provider<FavoriteRecipeRepository>(
  (ref) => FavoriteRecipeRepository(
    recipeLocalDataSource: ref.watch(recipeLocalDataSourceProvider),
  ),
);

final favoriteNotifierProvider =
    AsyncNotifierProvider<FavoriteNotifier, List<Recipe>>(FavoriteNotifier.new);
