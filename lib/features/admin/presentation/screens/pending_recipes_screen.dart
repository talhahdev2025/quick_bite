
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/admin/presentation/providers/providers.dart';
import 'package:quick_bite/features/admin/presentation/widgets/pending_recipe_card.dart';

class PendingRecipesScreen extends ConsumerWidget {
  const PendingRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(pendingRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Recipes'),
      ),
      body: recipes.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text('No pending recipes'),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return PendingRecipeCard(
                recipe: recipe,
              );
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}



//