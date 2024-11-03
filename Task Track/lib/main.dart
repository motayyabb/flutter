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

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(task['description']),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: task['isCompleted'] == 1 ? 1.0 : 0.2, // Example progress
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTaskList(List<Map<String, dynamic>> tasks) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(
              task['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(task['description']),
            trailing: task['isCompleted'] == 1
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.radio_button_unchecked, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final tasks = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Main Tasks",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: _buildDailyTaskList(tasks)),
            ],
          );
        },
      );
    } else if (_selectedIndex == 1) {
      return AddTaskScreen(onSubmit: widget.insertTask);
    } else {
      return Center(
        child: Text("Settings or other screens"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Management App"),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _buildBody(),
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
      ),
    );
  }
}
