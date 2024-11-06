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
  bool areNotificationsEnabled = true; // Track notification status

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String taskName) async {
    if (!areNotificationsEnabled) return; // Check if notifications are enabled

    var androidDetails = AndroidNotificationDetails(
        'channel_id', 'channel_name', importance: Importance.high, priority: Priority.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Task Added',
      'You added a new task: $taskName',
      generalNotificationDetails,
    );
  }

  Future<void> _showRepeatedNotification(String taskName) async {
    if (!areNotificationsEnabled) return; // Check if notifications are enabled

    var androidDetails = AndroidNotificationDetails(
        'repeated_task_id', 'repeated_task_name', importance: Importance.high, priority: Priority.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      'Repeated Task',
      'This task repeats. Check your repeated tasks list.',
      generalNotificationDetails,
    );
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
      // Removed RepeatedTaskScreen until it is defined
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
          backgroundColor: Colors.blueAccent, // Matching your color theme
          elevation: 5.0, // Add elevation for shadow effect
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, size: 30.0),
              onPressed: () {},
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
            // Removed RepeatedTaskScreen from navigation until it's defined
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Future<void> Function(String) notificationCallback;

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
                elevation: 8, // Slightly higher elevation for better shadow
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // Rounded corners
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
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await TaskDatabaseHelper.instance.deleteTask(task.id!);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task deleted')));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          task.isCompleted = true;
                          await TaskDatabaseHelper.instance.updateTask(task);
                          notificationCallback(task.name);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task marked as completed')));
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

class AddTaskScreen extends StatefulWidget {
  final Future<void> Function(String) notificationCallback;

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
      Task task = Task(
        name: _nameController.text,
        description: _descriptionController.text,
      );

      await TaskDatabaseHelper.instance.insertTask(task);
      widget.notificationCallback(task.name);
      Navigator.pop(context); // Go back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task added')));
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
                  backgroundColor: Colors.blueAccent, // Matching theme
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Better padding for buttons
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                widget.task.name = _nameController.text;
                widget.task.description = _descriptionController.text;
                await TaskDatabaseHelper.instance.updateTask(widget.task);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated')));
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

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
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            value: isDarkMode,
            onChanged: onDarkModeToggle,
            activeColor: Colors.blueAccent,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          SwitchListTile(
            title: Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            value: areNotificationsEnabled,
            onChanged: onNotificationToggle,
            activeColor: Colors.blueAccent,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ],
      ),
    );
  }
}
