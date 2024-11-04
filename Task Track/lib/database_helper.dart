import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton instance
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER, isRepeated INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(String title, String description, bool isRepeated) async {
    final db = await database;
    await db.insert(
      'tasks',
      {'title': title, 'description': description, 'isCompleted': 0, 'isRepeated': isRepeated ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTasks({bool completed = false, bool repeated = false}) async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'isCompleted = ? AND isRepeated = ?',
      whereArgs: [completed ? 1 : 0, repeated ? 1 : 0],
    );
  }

  Future<void> markTaskAsCompleted(int id) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isCompleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTask(int id, String title, String description) async {
    final db = await database;
    await db.update(
      'tasks',
      {'title': title, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
