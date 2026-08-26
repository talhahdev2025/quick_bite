import 'package:quick_bite/core/database/app_database.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';

class RecipeLocalDataSource {
  final AppDatabase _appDatabase;
  RecipeLocalDataSource({required this._appDatabase});

  //save recipe
  Future<void> addFavorite(RecipeModel recipeModel) async {
    final db = await _appDatabase.database;
    await db.insert(
      'recipes',
      recipeModel.toMapForSQFLite(),
      conflictAlgorithm: .replace,
    );
  }

  //get recipes
  Future<List<RecipeModel>> getFavorites() async {
    final db = await _appDatabase.database;
    final result = await db.query('recipes');
    // return result.map((e) => RecipeModel.fromMap(e)).toList();
    //TODO:change thsi line
    return result.map((e) => RecipeModel.fromMapForSQFLite(e)).toList();
  }

  //remove favorites
  Future<void> removeFavorite(int id) async {
    final db = await _appDatabase.database;
    db.delete('recipes', where: 'id=?', whereArgs: [id]);
  }

  //is favorite or not
  Future<bool> isFavorite(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query('recipes', where: 'id=?', whereArgs: [id]);
    return maps.isNotEmpty;
  }
}
