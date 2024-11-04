import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'database_helper.dart';

void main() {
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatefulWidget {
  @override
  _TaskManagementAppState createState() => _TaskManagementAppState();
}

class _TaskManagementAppState extends State<TaskManagementApp> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your_channel_id', 'your_channel_name',
        importance: Importance.high, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> insertTask(String title, String description, bool isRepeated) async {
    bool taskExists = await dbHelper.checkTaskExists(title);
    if (taskExists) {
      _showNotification("Duplicate Task", "Task '$title' already exists.");
    } else {
      await dbHelper.insertTask(title, description, isRepeated);
      _showNotification("Task Added", "New task '$title' has been added.");
    }
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> getTasks({bool completed = false, bool repeated = false}) async {
    return await dbHelper.getTasks(completed: completed, repeated: repeated);
  }

  Future<void> markTaskAsCompleted(int id) async {
    await dbHelper.markTaskAsCompleted(id);
    setState(() {});
  }

  Future<void> deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    setState(() {});
  }

  Future<void> updateTask(int id, String title, String description) async {
    await dbHelper.updateTask(id, title, description);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
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

extension on DatabaseHelper {
  checkTaskExists(String title) {}
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
            return AnimatedCard(
              child: ListTile(
                title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(task['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.amberAccent),
                      onPressed: () {
                        // Add update task code
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => widget.deleteTask(task['id']),
                    ),
                    if (!completed)
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.greenAccent),
                        onPressed: () => widget.markTaskAsCompleted(task['id']),
                      ),
                  ],
                ),
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
      appBar: AppBar(
        title: Text("Task Manager", style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.deepPurple[700],
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.deepPurple[50],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.add_task), label: "New Task"),
          BottomNavigationBarItem(icon: Icon(Icons.done_all), label: "Completed"),
          BottomNavigationBarItem(icon: Icon(Icons.repeat_on), label: "Repeats"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  final Function(String, String, bool) onSubmit;

  AddTaskScreen({required this.onSubmit});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isRepeated = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Title",
            prefixIcon: Icon(Icons.title),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: "Description",
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SwitchListTile(
          title: Text("Repeat Task"),
          value: isRepeated,
          onChanged: (value) {
            setState(() {
              isRepeated = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(titleController.text, descriptionController.text, isRepeated);
          },
          child: Text("Add Task"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
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
        child: Text("Toggle Dark/Light Mode"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;

  AnimatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
