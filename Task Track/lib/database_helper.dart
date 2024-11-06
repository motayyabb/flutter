import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'notification_helper.dart';

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

    final notificationHelper = NotificationHelper();
    await notificationHelper.showNotification('Task Completed', 'Task ID: $id has been completed.');
  }
}
