import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/network/api_client.dart';
import 'package:quick_bite/features/home/data/datasources/recipe_remote_data_source.dart';
import 'package:quick_bite/features/home/data/repositories/recipe_repository.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final recipeRemoteDataSourceProvier = Provider(
  (ref) => RecipeRemoteDataSource(apiClient: ref.read(apiClientProvider)),
);
final recipeRepositoryProvider = Provider(
  (ref) => RecipeRepository(
    recipeRemoteDataSource: ref.read(recipeRemoteDataSourceProvier),
  ),
);

//
final recipeProvider = FutureProvider<List<Recipe>>(
  (ref) => ref.read(recipeRepositoryProvider).getRecipes(),
);
