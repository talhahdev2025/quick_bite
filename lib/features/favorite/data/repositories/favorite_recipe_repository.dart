import 'package:quick_bite/features/favorite/data/datasources/recipe_local_data_source.dart';
import 'package:quick_bite/features/recipe/data/models/recipe_model.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class FavoriteRecipeRepository {
  final RecipeLocalDataSource recipeLocalDataSource;

  FavoriteRecipeRepository({
    required this.recipeLocalDataSource,
  });

  Future<List<Recipe>> getFavorites() async {
    final recipes = await recipeLocalDataSource.getFavorites();
    return recipes.map((e) => e.toEntity()).toList();
  }

  Future<void> addFavorite(Recipe recipe) async {
    final recipeModel = RecipeModel.fromEntity(recipe);
    await recipeLocalDataSource.addFavorite(recipeModel);
  }

  Future<void> removeFavorite(String id) async {
    await recipeLocalDataSource.removeFavorite(id);
  }

  Future<bool> isFavorite(String id) async {
    return await recipeLocalDataSource.isFavorite(id);
  }
}

