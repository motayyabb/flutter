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
  String successMessage = '';

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

  void _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(),
      ),
    );
    if (result != null && result) {
      setState(() {
        successMessage = 'Task successfully added!';
      });
      _loadTasks(); // Refresh the task list
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Implement navigation to different screens if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality can be added here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (successMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                successMessage,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text("No tasks available", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)))
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(tasks[index].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(tasks[index].dueDate, style: TextStyle(color: Colors.grey[600])),
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
          ),
        ],
      ),
      floatingActionButton: null, // Remove the standalone floating button
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'), // Add Task icon in navbar
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Repeated Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) { // If Add Task is tapped
            _navigateToAddTask();
          } else {
            _onItemTapped(index); // Other tab functionality
          }
        },
      ),
    );
  }
}
