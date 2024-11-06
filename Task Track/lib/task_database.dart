import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task.dart';

class TaskDatabaseHelper {
  static final TaskDatabaseHelper instance = TaskDatabaseHelper._init();
  static Database? _database;

  TaskDatabaseHelper._init();

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
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getRepeatedTasks() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT * FROM tasks
      WHERE name IN (SELECT name FROM tasks GROUP BY name HAVING COUNT(name) > 1)
    ''');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getCompletedTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    return result.map((map) => Task.fromMap(map)).toList();
  }
}
