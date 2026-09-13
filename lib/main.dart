import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/app.dart';
import 'package:quick_bite/core/network/api_client.dart';
import 'package:quick_bite/core/utils/recipe_seeder.dart';
import 'package:quick_bite/features/recipe/data/datasources/recipe_remote_data_source.dart';
import 'package:quick_bite/features/recipe/data/repositories/recipe_repository.dart';
import 'package:quick_bite/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final seeder = RecipeSeeder(
  //   apiDataSource: RecipeRepository(
  //     recipeRemoteDataSource: RecipeRemoteDataSource(apiClient: ApiClient()),
  //   ),
  //   firestore: FirebaseFirestore.instance,
  // );
  // await seeder.seedApiRecipesToFirestore();
  
  runApp(const ProviderScope(child: QuickBite()));
}
