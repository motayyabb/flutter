import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'notification_helper.dart'; // Ensure this import is included

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER, isRepeated INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Show notification when a new task is added
    final notificationHelper = NotificationHelper();
    await notificationHelper.showNotification('New Task Added', task['title']);
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

    // Show notification when a task is completed
    final notificationHelper = NotificationHelper();
    await notificationHelper.showNotification('Task Completed', 'Task ID: $id has been completed.');
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Show notification when a task is deleted
    final notificationHelper = NotificationHelper();
    await notificationHelper.showNotification('Task Deleted', 'Task ID: $id has been deleted.');
  }

  Future<void> updateTask(int id, String title, String description) async {
    final db = await database;
    await db.update(
      'tasks',
      {'title': title, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );

    // Show notification when a task is updated
    final notificationHelper = NotificationHelper();
    await notificationHelper.showNotification('Task Updated', 'Task ID: $id has been updated.');
  }
}
