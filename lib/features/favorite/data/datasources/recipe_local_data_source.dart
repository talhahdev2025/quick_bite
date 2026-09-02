import 'package:quick_bite/core/database/app_database.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';
import 'package:sqflite/sqflite.dart';

class RecipeLocalDataSource {
  final AppDatabase appDatabase;
  RecipeLocalDataSource({required this.appDatabase});

  // Save recipe
  Future<void> addFavorite(RecipeModel recipeModel) async {
    final db = await appDatabase.database;
    await db.insert(
      'recipes',
      recipeModel.toMapForSQFLite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get recipes
  Future<List<RecipeModel>> getFavorites() async {
    final db = await appDatabase.database;
    final result = await db.query('recipes');
    return result.map((e) => RecipeModel.fromMapForSQFLite(e)).toList();
  }

  // Remove favorite
  Future<void> removeFavorite(int id) async {
    final db = await appDatabase.database;
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  // Is favorite or not
  Future<bool> isFavorite(int id) async {
    final db = await appDatabase.database;
    final maps = await db.query('recipes', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }
}

