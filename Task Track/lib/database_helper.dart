import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, dueDate TEXT, isCompleted INTEGER, repeatInterval TEXT)',
      );
    });
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTodayTasks() async {
    final db = await database;
    String today = DateTime.now().toIso8601String().substring(0, 10);
    return await db.query('tasks', where: 'dueDate = ?', whereArgs: [today]);
  }

  Future<List<Map<String, dynamic>>> getCompletedTasks() async {
    final db = await database;
    return await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
  }

  Future<List<Map<String, dynamic>>> getRepeatedTasks() async {
    final db = await database;
    return await db.query('tasks', where: 'repeatInterval IS NOT NULL');
  }

  Future<void> updateTask(int id, Map<String, dynamic> task) async {
    final db = await database;
    await db.update('tasks', task, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
