import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Base de datos de Builds
class BuildsDataBase {
  static final BuildsDataBase instance = BuildsDataBase._init();

  static Database? _database;

  BuildsDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('builds.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(''' 
        CREATE TABLE builds (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name_buil TEXT,
          champion TEXT,
          item1 TEXT,
          item2 TEXT,
          item3 TEXT,
          item4 TEXT,
          item5 TEXT,
          item6 TEXT,
          additionalItem1 TEXT,
          additionalItem2 TEXT,
          additionalItem3 TEXT,
          additionalItem4 TEXT,
          additionalItem5 TEXT,
          additionalItem6 TEXT
        )
      ''');
    });
  }

  // Método para insertar una Build
  Future<void> insertBuild(Map<String, dynamic> build) async {
    final db = await instance.database;
    await db.insert('builds', build, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Método para obtener todos los Builds
  Future<List<Map<String, dynamic>>> fetchBuilds() async {
    final db = await instance.database;
    return await db.query('builds');
  }

  // Método para eliminar una Build por su ID
  Future<void> deleteBuild(int id) async {
    final db = await instance.database;
    try {
      await db.delete(
        'builds', // Nombre de la tabla
        where: 'id = ?', // Condición
        whereArgs: [id], // Valor del parámetro
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error al eliminar la build: $e");
    }
  }
}
