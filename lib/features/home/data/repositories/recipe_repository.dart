import 'package:quick_bite/features/home/data/datasources/recipe_remote_data_source.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class RecipeRepository {
  final RecipeRemoteDataSource _recipeRemoteDataSource;

  RecipeRepository({required this._recipeRemoteDataSource});

  Future<List<Recipe>> getRecipes() async {
    final recipieModels = await _recipeRemoteDataSource.getRecipies();
    return recipieModels.map((recipeModel) => recipeModel.toEntity()).toList();
  }
}
