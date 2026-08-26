import 'package:flutter/widgets.dart';
import 'package:quick_bite/features/favorite/data/datasources/recipe_local_data_source.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class FavoriteRecipeRepository {
  final RecipeLocalDataSource _recipeLocalDataSource;

  FavoriteRecipeRepository({required this._recipeLocalDataSource});

  Future<List<Recipe>> getFavorites() async {
    final recipes = await _recipeLocalDataSource.getFavorites();
    return recipes.map((e) => e.toEntity()).toList();
  }

  Future<void> addFavorite(Recipe recipe) {
    final recipeModel = RecipeModel.fromEntity(recipe);
    return _recipeLocalDataSource.addFavorite(recipeModel);
  }

  Future<void> removeFavorite(int id) =>
      _recipeLocalDataSource.removeFavorite(id);

  Future<bool> isFavorite(int id) => _recipeLocalDataSource.isFavorite(id);
}
