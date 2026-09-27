import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/recipe/data/datasources/recipe_firestore_data_source.dart';
import 'package:quick_bite/features/recipe/data/repositories/recipe_firestore_repository.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

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

//current user id provider
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.uid;
});

final userSubmissionsStreamProvider = StreamProvider<List<Recipe>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null || userId.isEmpty) {
    return Stream.value([]);
  }

  final repository = ref.watch(recipeFirestoreRepositoryProvider);
  return repository.getUserRecipe(userId);
});
