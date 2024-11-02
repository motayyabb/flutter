// completed_tasks_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';

class CompletedTasksScreen extends StatefulWidget {
  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _completedTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedTasks();
  }

  void _fetchCompletedTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getTasks(completed: true);
    setState(() {
      _completedTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        centerTitle: true,
      ),
      body: _completedTasks.isEmpty
          ? Center(child: Text('No completed tasks yet!'))
          : ListView.builder(
        itemCount: _completedTasks.length,
        itemBuilder: (context, index) {
          final task = _completedTasks[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Completed on: ${task['datetime']}'),
            ),
          );
        },
      ),
    );
  }
}
