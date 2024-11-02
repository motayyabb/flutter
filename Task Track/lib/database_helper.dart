import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT,
        time TEXT,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<int> addTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await instance.database;
    return await db.query('tasks');
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    final db = await instance.database;
    return await db.update('tasks', task, where: 'id = ?', whereArgs: [task['id']]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> markAsCompleted(int id) async {
    final db = await instance.database;
    return await db.update('tasks', {'isCompleted': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
