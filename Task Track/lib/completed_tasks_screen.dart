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
      ),
      body: ListView.builder(
        itemCount: _completedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_completedTasks[index]['title']),
          );
        },
      ),
    );
  }
}
