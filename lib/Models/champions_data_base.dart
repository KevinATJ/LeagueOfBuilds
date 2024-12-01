import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Base de datos de Champions
class ChampionsDataBase {
  static final ChampionsDataBase instance = ChampionsDataBase._init();

  static Database? _database;

  ChampionsDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('champions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(''' 
        CREATE TABLE champions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          image_full TEXT
        )
      ''');
    });
  }

  // Método para insertar un Champion
  Future<void> insertChampion(Map<String, dynamic> champion) async {
    final db = await instance.database;
    await db.insert('champions', champion, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Método para obtener todos los Champions
  Future<List<Map<String, dynamic>>> fetchChampions() async {
    final db = await instance.database;
    return await db.query('champions');
  }
}
