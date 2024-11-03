import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatefulWidget {
  @override
  _TaskManagementAppState createState() => _TaskManagementAppState();
}

class _TaskManagementAppState extends State<TaskManagementApp> {
  late Database database;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER, isRepeated INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(String title, String description, bool isRepeated) async {
    await database.insert(
      'tasks',
      {'title': title, 'description': description, 'isCompleted': 0, 'isRepeated': isRepeated ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> getTasks({bool completed = false, bool repeated = false}) async {
    return await database.query(
      'tasks',
      where: 'isCompleted = ? AND isRepeated = ?',
      whereArgs: [completed ? 1 : 0, repeated ? 1 : 0],
    );
  }

  Future<void> markTaskAsCompleted(int id) async {
    await database.update(
      'tasks',
      {'isCompleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  Future<void> deleteTask(int id) async {
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  Future<void> updateTask(int id, String title, String description) async {
    await database.update(
      'tasks',
      {'title': title, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(
        insertTask: insertTask,
        getTasks: getTasks,
        markTaskAsCompleted: markTaskAsCompleted,
        deleteTask: deleteTask,
        updateTask: updateTask,
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(String, String, bool) insertTask;
  final Future<List<Map<String, dynamic>>> Function({bool completed, bool repeated}) getTasks;
  final Function(int) markTaskAsCompleted;
  final Function(int) deleteTask;
  final Function(int, String, String) updateTask;
  final VoidCallback toggleTheme;

  HomeScreen({
    required this.insertTask,
    required this.getTasks,
    required this.markTaskAsCompleted,
    required this.deleteTask,
    required this.updateTask,
    required this.toggleTheme,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget _buildTaskList(bool completed, bool repeated) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.getTasks(completed: completed, repeated: repeated),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data!;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task['title']),
              subtitle: Text(task['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Call updateTask here
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => widget.deleteTask(task['id']),
                  ),
                  if (!completed)
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => widget.markTaskAsCompleted(task['id']),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildTaskList(false, false); // Active Tasks
      case 1:
        return AddTaskScreen(onSubmit: widget.insertTask);
      case 2:
        return _buildTaskList(true, false); // Completed Tasks
      case 3:
        return _buildTaskList(false, true); // Repeated Tasks
      case 4:
        return SettingsScreen(toggleTheme: widget.toggleTheme);
      default:
        return _buildTaskList(false, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Management App")),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Task"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Completed"),
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: "Repeated"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final Function(String, String, bool) onSubmit;

  AddTaskScreen({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isRepeated = false;

    return Column(
      children: [
        TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
        TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
        SwitchListTile(
          title: Text("Repeat Task"),
          value: isRepeated,
          onChanged: (value) => isRepeated = value,
        ),
        ElevatedButton(
          onPressed: () {
            onSubmit(titleController.text, descriptionController.text, isRepeated);
          },
          child: Text("Add Task"),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  SettingsScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: toggleTheme,
            child: Text("Toggle Dark/Light Theme"),
         ),
        );
    }
}