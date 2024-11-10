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
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  // Create the table with the new fields 'repeat' and 'repeatDays'
  Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        isCompleted INTEGER,
        repeat INTEGER,
        repeatDays TEXT
      )
    ''');
  }

  // Handle upgrading database schema (when new columns are added)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE tasks ADD COLUMN repeat INTEGER DEFAULT 0
      ''');
      await db.execute('''
        ALTER TABLE tasks ADD COLUMN repeatDays TEXT
      ''');
    }
  }

  // Insert a task into the database
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  // Retrieve all tasks from the database
  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Update a task in the database
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // Delete a task from the database
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Get tasks that repeat
  Future<List<Task>> getRepeatedTasks() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT * FROM tasks
      WHERE repeat = 1
    ''');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Get completed tasks
  Future<List<Task>> getCompletedTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    return result.map((map) => Task.fromMap(map)).toList();
  }
}
