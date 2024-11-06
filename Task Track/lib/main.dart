import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'task_database.dart';
import 'task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isDarkMode = false;
  bool areNotificationsEnabled = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    if (!areNotificationsEnabled) return;
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(body, htmlFormatBigText: true, contentTitle: title, htmlFormatContentTitle: true),
      color: Colors.blueAccent,
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      icon: 'app_icon',
    );
    NotificationDetails generalNotificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, generalNotificationDetails);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      HomeScreen(notificationCallback: _showNotification),
      AddTaskScreen(notificationCallback: _showNotification),
      CompletedTasksScreen(notificationCallback: _showNotification),
      RepeatedTasksScreen(notificationCallback: _showNotification),
      SettingsScreen(
        onDarkModeToggle: (bool value) {
          setState(() {
            isDarkMode = value;
          });
        },
        onNotificationToggle: (bool value) {
          setState(() {
            areNotificationsEnabled = value;
          });
        },
        isDarkMode: isDarkMode,
        areNotificationsEnabled: areNotificationsEnabled,
      ),
    ];

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Task Management',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 5.0,
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
            BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Completed Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Repeated Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          selectedItemColor: Colors.white, // White text for selected item
          unselectedItemColor: Colors.blueAccent, // Blue accent for unselected items
          backgroundColor: Colors.blueAccent, // Blue accent background
        ),
      ),
    );
  }
}

// HomeScreen - Displays all tasks
class HomeScreen extends StatelessWidget {
  final Future<void> Function(String, String) notificationCallback;

  HomeScreen({required this.notificationCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        future: TaskDatabaseHelper.instance.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found.'));
          }

          var tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 8,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title: Text(
                    task.name,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(task: task),
                            ),
                          ).then((_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated'))));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await TaskDatabaseHelper.instance.deleteTask(task.id!);
                          notificationCallback("Task Deleted", "${task.name} has been deleted.");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task deleted')));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          task.isCompleted = true;
                          await TaskDatabaseHelper.instance.updateTask(task);
                          notificationCallback("Task Completed", "${task.name} is marked as completed.");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task completed')));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// CompletedTasksScreen - Displays completed tasks
class CompletedTasksScreen extends StatelessWidget {
  final Future<void> Function(String, String) notificationCallback;

  CompletedTasksScreen({required this.notificationCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        future: TaskDatabaseHelper.instance.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No completed tasks found.'));
          }

          var tasks = snapshot.data!.where((task) => task.isCompleted).toList();
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 8,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title: Text(
                    task.name,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(task.description),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// RepeatedTasksScreen - Displays repeated tasks
class RepeatedTasksScreen extends StatelessWidget {
  final Future<void> Function(String, String) notificationCallback;

  RepeatedTasksScreen({required this.notificationCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        future: TaskDatabaseHelper.instance.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No repeated tasks found.'));
          }

          var tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              if (task.name.contains("Repeat")) { // Assuming repeated tasks have "Repeat" in their name
                return Card(
                  elevation: 8,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: ListTile(
                    title: Text(
                      task.name,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(task.description),
                  ),
                );
              }
              return Container(); // For non-repeated tasks
            },
          );
        },
      ),
    );
  }
}
// AddTaskScreen - Add a new task
class AddTaskScreen extends StatefulWidget {
  final Future<void> Function(String, String) notificationCallback;

  AddTaskScreen({required this.notificationCallback});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void _addTask() async {
    if (_formKey.currentState!.validate()) {
      String taskName = _nameController.text;
      var existingTasks = await TaskDatabaseHelper.instance.getTasks();
      bool taskExists = existingTasks.any((task) => task.name == taskName);

      if (taskExists) {
        widget.notificationCallback("Task Exists", "The task '$taskName' already exists.");
        return;
      }

      Task task = Task(
        name: taskName,
        description: _descriptionController.text,
      );

      await TaskDatabaseHelper.instance.insertTask(task);
      widget.notificationCallback("New Task Added", "The task '$taskName' has been added.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task added')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// EditTaskScreen - Edit an existing task
class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  void _updateTask() async {
    if (_nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      widget.task.name = _nameController.text;
      widget.task.description = _descriptionController.text;

      await TaskDatabaseHelper.instance.updateTask(widget.task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}

// SettingsScreen - Settings screen for dark mode and notifications
class SettingsScreen extends StatelessWidget {
  final Function(bool) onDarkModeToggle;
  final Function(bool) onNotificationToggle;
  final bool isDarkMode;
  final bool areNotificationsEnabled;

  SettingsScreen({
    required this.onDarkModeToggle,
    required this.onNotificationToggle,
    required this.isDarkMode,
    required this.areNotificationsEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode,
              onChanged: onDarkModeToggle,
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: areNotificationsEnabled,
              onChanged: onNotificationToggle,
            ),
          ],
        ),
      ),
    );
  }
}
