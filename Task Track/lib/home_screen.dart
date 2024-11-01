import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Task> tasks = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final taskList = await dbHelper.getTasks();
    setState(() {
      tasks = taskList.map((taskMap) => Task.fromMap(taskMap)).toList();
    });
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(onTaskAdded: _loadTasks),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Implement the functionality for different bottom nav items here
    // For example, navigate to different screens or show dialogs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            child: ListTile(
              title: Text(tasks[index].title),
              subtitle: Text(tasks[index].dueDate),
              trailing: Checkbox(
                value: tasks[index].isCompleted,
                onChanged: (value) {
                  dbHelper.updateTask(tasks[index].id, Task(
                    id: tasks[index].id,
                    title: tasks[index].title,
                    description: tasks[index].description,
                    dueDate: tasks[index].dueDate,
                    isCompleted: value ?? false,
                    isRepeated: tasks[index].isRepeated,
                  ));
                  _loadTasks();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Repeated Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
