import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, isRepeated INTEGER, isCompleted INTEGER, date TEXT, time TEXT)",
        );
      },
    );
  }

  Future<void> insertTask(String title, String description, bool isRepeated, bool isCompleted, String date, String time) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'title': title,
        'description': description,
        'isRepeated': isRepeated ? 1 : 0,
        'isCompleted': isCompleted ? 1 : 0,
        'date': date,
        'time': time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<List<Map<String, dynamic>>> getTodayTasks() async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'DATE(date) = DATE("now")',
    );
  }

  Future<List<Map<String, dynamic>>> getRepeatedTasks() async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'isRepeated = 1',
    );
  }

  Future<List<Map<String, dynamic>>> getCompletedTasks() async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'isCompleted = 1',
    );
  }

  Future<void> updateTask(int id, String title, String description, bool isRepeated, bool isCompleted, String date, String time) async {
    final db = await database;
    await db.update('tasks', {
      'title': title,
      'description': description,
      'isRepeated': isRepeated ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date,
      'time': time,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
