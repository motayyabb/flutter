import 'package:flutter/material.dart';
import 'database_helper.dart';

class CompletedTasksScreen extends StatefulWidget {
  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getCompletedTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(_tasks[index]['title']),
              subtitle: Text(_tasks[index]['description'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}
