import 'package:quick_bite/features/recipe/data/datasources/recipe_firestore_data_source.dart';
import 'package:quick_bite/features/recipe/data/models/recipe_model.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class RecipeRepository {
  final RecipeFirestoreDataSource _remoteDataSource;

  RecipeRepository({required this._remoteDataSource});

  //approve recipe
  Future<void> approveRecipe(String recipeId) async {
    await _remoteDataSource.approveRecipe(recipeId);
  }

  //
  Future<void> rejectRecipe(String recipeId, String rejectReason) async {
    await _remoteDataSource.rejectRecipe(recipeId, rejectReason);
  }

  //save recipe
  Future<void> saveRecipe(Recipe recipe) {
    final model = RecipeModel.fromEntity(recipe);
    return _remoteDataSource.addRecipe(model.toMap());
  }

  //get approved recipes
  Stream<List<Recipe>> getApprovedRecipes() {
    return _remoteDataSource.getRecipes().map((models) {
      return models.map((model) => model.toEntity()).toList();
    });
  }

  //get pending recipes
  Stream<List<Recipe>> getPendingRecipes() {
    return _remoteDataSource.getPendingRecipes().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  //get user recipes
  Stream<List<Recipe>> getUserRecipe(String userId) {
    return _remoteDataSource
        .getUserRecipes(userId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  //update recipe

  Future<void> updateRecipe(String id, Recipe recipe)  {
    final data = RecipeModel.fromEntity(recipe);
    return _remoteDataSource.updateRecipe(id, data.toMap());
  }
}
