// repeated_tasks_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';

class RepeatedTasksScreen extends StatefulWidget {
  @override
  _RepeatedTasksScreenState createState() => _RepeatedTasksScreenState();
}

class _RepeatedTasksScreenState extends State<RepeatedTasksScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _repeatedTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchRepeatedTasks();
  }

  void _fetchRepeatedTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getRepeatedTasks();
    setState(() {
      _repeatedTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repeated Tasks'),
      ),
      body: ListView.builder(
        itemCount: _repeatedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_repeatedTasks[index]['title']),
          );
        },
      ),
    );
  }
}
