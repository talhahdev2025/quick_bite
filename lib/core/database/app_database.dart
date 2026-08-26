import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String _databaseName = 'my_app.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    return await db.execute('''
  CREATE TABLE recipes (
    id INTEGER PRIMARY KEY,
    name TEXT,
    ingredients TEXT,
    instructions TEXT,
    prepTimeMinutes INTEGER,
    cookTimeMinutes INTEGER,
    servings INTEGER,
    difficulty TEXT,
    cuisine TEXT,
    caloriesPerServing INTEGER,
    tags TEXT,
    userId INTEGER,
    image TEXT,
    rating REAL,
    reviewCount INTEGER,
    mealType TEXT
  )
''');
  }
}
