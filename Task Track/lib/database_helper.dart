// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        completed INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insertTask(String title) async {
    final db = await database;
    await db.insert('tasks', {'title': title});
  }

  Future<void> markTaskAsCompleted(int id) async {
    final db = await database;
    await db.update('tasks', {'completed': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTasks({bool completed = false}) async {
    final db = await database;
    return await db.query('tasks', where: 'completed = ?', whereArgs: [completed ? 1 : 0]);
  }
}
