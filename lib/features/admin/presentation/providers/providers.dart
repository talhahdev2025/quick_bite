import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/home/presentation/provider/providers.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

final pendingRecipesProvider = StreamProvider<List<Recipe>>(
  (ref) => ref.watch(recipeRepositoryProvider).getPendingRecipes(),
);
