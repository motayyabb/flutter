import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationHelper = NotificationHelper();
  await notificationHelper.initNotifications();
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isDarkMode = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      TaskListScreen(),
      AddTaskScreen(),
      CompletedTasksScreen(),
      RepeatedTasksScreen(),
      SettingsScreen(
        isDarkMode: isDarkMode,
        onDarkModeToggle: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Management"),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Task"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Completed"),
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: "Repeated"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    tasks = await dbHelper.getTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task['title']),
          subtitle: Text(task['description']),
          trailing: IconButton(
            icon: Icon(Icons.check, color: task['isCompleted'] == 1 ? Colors.green : Colors.grey),
            onPressed: () async {
              await dbHelper.markTaskAsCompleted(task['id']);
              _loadTasks();
            },
          ),
        );
      },
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper();
  final notificationHelper = NotificationHelper();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Task Description'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await dbHelper.insertTask({
                'title': titleController.text,
                'description': descriptionController.text,
                'isCompleted': 0,
                'isRepeated': 0,
              });
              notificationHelper.showNotification("New Task", "Task '${titleController.text}' added.");
              Navigator.pop(context);
            },
            child: Text('Add Task'),
          ),
        ],
      ),
    );
  }
}

class CompletedTasksScreen extends StatefulWidget {
  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }

  void _loadCompletedTasks() async {
    completedTasks = await dbHelper.getTasks(completed: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: completedTasks.length,
      itemBuilder: (context, index) {
        final task = completedTasks[index];
        return ListTile(
          title: Text(task['title']),
          subtitle: Text(task['description']),
        );
      },
    );
  }
}

class RepeatedTasksScreen extends StatefulWidget {
  @override
  _RepeatedTasksScreenState createState() => _RepeatedTasksScreenState();
}

class _RepeatedTasksScreenState extends State<RepeatedTasksScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> repeatedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadRepeatedTasks();
  }

  void _loadRepeatedTasks() async {
    repeatedTasks = await dbHelper.getTasks(repeated: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: repeatedTasks.length,
      itemBuilder: (context, index) {
        final task = repeatedTasks[index];
        return ListTile(
          title: Text(task['title']),
          subtitle: Text(task['description']),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeToggle;

  SettingsScreen({required this.isDarkMode, required this.onDarkModeToggle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SwitchListTile(
        title: Text("Dark Mode"),
        value: isDarkMode,
        onChanged: onDarkModeToggle,
      ),
    );
  }
}
