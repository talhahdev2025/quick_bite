import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/network/api_client.dart';
import 'package:quick_bite/features/home/data/datasources/recipe_remote_data_source.dart';
import 'package:quick_bite/features/home/data/repositories/recipe_repository.dart';
import 'package:quick_bite/features/home/domain/recipe.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final recipeRemoteDataSourceProvider = Provider<RecipeRemoteDataSource>(
  (ref) => RecipeRemoteDataSource(apiClient: ref.watch(apiClientProvider)),
);

// Backward compatibility alias
final recipeRemoteDataSourceProvier = recipeRemoteDataSourceProvider;

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepository(
    recipeRemoteDataSource: ref.watch(recipeRemoteDataSourceProvider),
  ),
);

final recipeProvider = FutureProvider<List<Recipe>>(
  (ref) => ref.watch(recipeRepositoryProvider).getRecipes(),
);

// Search Query Notifier & Provider
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

// Filtered Recipes Provider based on search
final filteredRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final recipesAsync = ref.watch(recipeProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) return recipesAsync;

  return recipesAsync.whenData((recipes) {
    return recipes.where((recipe) {
      final name = recipe.name?.toLowerCase() ?? '';
      final cuisine = recipe.cuisine?.toLowerCase() ?? '';
      final difficulty = recipe.difficulty?.toLowerCase() ?? '';
      final tags = (recipe.tags ?? []).map((t) => t.toLowerCase()).join(' ');

      return name.contains(query) ||
          cuisine.contains(query) ||
          difficulty.contains(query) ||
          tags.contains(query);
    }).toList();
  });
});


