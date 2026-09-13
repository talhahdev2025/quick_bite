// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:quick_bite/features/recipe/data/models/recipe_model.dart';
// import 'package:quick_bite/features/recipe/data/repositories/recipe_repository.dart';
// import 'package:quick_bite/features/recipe/domain/recipe.dart';

// class RecipeSeeder {
//   final RecipeRepository apiDataSource;
//   final FirebaseFirestore firestore;

//   RecipeSeeder({required this.apiDataSource, FirebaseFirestore? firestore})
//     : firestore = firestore ?? FirebaseFirestore.instance;

//   Future<void> seedApiRecipesToFirestore() async {
//     try {
//       final List<Recipe> apiRecipes = await apiDataSource.getRecipes();

//       if (apiRecipes.isEmpty) {
//         debugPrint('No recipes returned from API source.');
//         return;
//       }

//       final WriteBatch batch = firestore.batch();
//       final collectionRef = firestore.collection('recipes');

//       for (final recipe in apiRecipes) {
//         final docRef = collectionRef
//             .doc(); // Auto-generates unique Firestore Document Reference

//         // 1. Convert domain entity to model map
//         final recipeModel = RecipeModel.fromEntity(recipe);
//         final Map<String, dynamic> recipeData = recipeModel.toMap();

//         // 2. Add approval status and preserve original integer API ID
//         recipeData['status'] = 'approved';
//         recipeData['id'] =
//             docRef.id; // Optional: store document key separately

//         batch.set(docRef, recipeData);
//       }

//       await batch.commit();
//       debugPrint(
//         'Successfully seeded ${apiRecipes.length} recipes to Firestore.',
//       );
//     } catch (e) {
//       debugPrint('Failed to seed recipes: $e');
//     }
//   }
// }
