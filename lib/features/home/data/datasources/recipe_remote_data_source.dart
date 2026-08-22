import 'package:quick_bite/core/network/api_client.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';

class RecipeRemoteDataSource {
  final ApiClient _apiClient;
  RecipeRemoteDataSource({required this._apiClient});

  Future<List<RecipeModel>> getRecipies() async {
    final response = await _apiClient.get(endpoint: '');
    final List<dynamic> data = response['recipes'];
    return data
        .map((recipe) => RecipeModel.fromMap(recipe as Map<String, dynamic>))
        .toList();
  }
}
