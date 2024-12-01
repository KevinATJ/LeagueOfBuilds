import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ItemsDataBase {
  static final ItemsDataBase instance = ItemsDataBase._init();

  static Database? _database;

  ItemsDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          image_full TEXT
        )
      ''');
    });
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    await db.insert('items', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await instance.database;
    return await db.query('items');
  }
}
