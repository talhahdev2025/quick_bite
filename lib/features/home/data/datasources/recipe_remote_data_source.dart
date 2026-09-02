import 'package:quick_bite/core/network/api_client.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';

class RecipeRemoteDataSource {
  final ApiClient apiClient;
  RecipeRemoteDataSource({required this.apiClient});

  Future<List<RecipeModel>> getRecipes() async {
    final dynamic response = await apiClient.get(endpoint: '');
    if (response is Map<String, dynamic> && response['recipes'] is List) {
      final List<dynamic> data = response['recipes'] as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map((recipe) => RecipeModel.fromMap(recipe))
          .toList();
    }
    return [];
  }

  // Backward compatibility alias
  Future<List<RecipeModel>> getRecipies() => getRecipes();
}

