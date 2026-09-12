import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/recipe/data/datasources/recipe_firestore_data_source.dart';
import 'package:quick_bite/features/recipe/data/models/recipe_model.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class RecipeRepository {
  final RecipeFirestoreDataSource _remoteDataSource;

  RecipeRepository({required this._remoteDataSource});
  //save recipe
  Future<void> saveRecipe(RecipeModel recipeModel) {
    final recipe = recipeModel.toMap();
    return _remoteDataSource.addRecipe(recipe);
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
}

final recipeFirestoreDataSourceProvider = Provider<RecipeFirestoreDataSource>(
  (ref) => RecipeFirestoreDataSource(),
);
final recipeFirestoreRepositoryProvider = Provider<RecipeRepository>((ref) {
  final remoteDataSource = ref.watch(recipeFirestoreDataSourceProvider);
  return RecipeRepository(remoteDataSource: remoteDataSource);
});
final approvedRecipesStreamProvider = StreamProvider<List<Recipe>>((ref) {
  final repository = ref.watch(recipeFirestoreRepositoryProvider);
  return repository.getApprovedRecipes();
});
