import 'package:quick_bite/features/home/data/datasources/recipe_remote_data_source.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

class RecipeRepository {
  final RecipeRemoteDataSource recipeRemoteDataSource;

  RecipeRepository({required this.recipeRemoteDataSource});

  Future<List<Recipe>> getRecipes() async {
    final recipeModels = await recipeRemoteDataSource.getRecipes();
    return recipeModels.map((recipeModel) => recipeModel.toEntity()).toList();
  }
}

