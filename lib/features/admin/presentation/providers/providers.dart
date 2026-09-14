import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/home/presentation/provider/providers.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

// 1. Declare StreamNotifierProvider instead of StreamProvider
final pendingRecipesNotifierProvider =
    StreamNotifierProvider<PendingRecipesNotifier, List<Recipe>>(
      PendingRecipesNotifier.new,
    );

// 2. Specify the generic type <List<Recipe>> on StreamNotifier
class PendingRecipesNotifier extends StreamNotifier<List<Recipe>> {
  @override
  Stream<List<Recipe>> build() {
    return ref.watch(recipeRepositoryProvider).getPendingRecipes();
  }

  Future<void> rejectRecipe({
    required String recipeId,
    required String rejectReason,
  }) async {
    await ref
        .read(recipeRepositoryProvider)
        .rejectRecipe(recipeId, rejectReason);
  }

  Future<void> approveRecipe(String recipeId) async {
    await ref.read(recipeRepositoryProvider).approveRecipe(recipeId);
  }
}
