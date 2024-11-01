import 'package:flutter/material.dart';
import 'database_helper.dart';

class TodayTasksScreen extends StatefulWidget {
  @override
  _TodayTasksScreenState createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getTodayTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Tasks'),
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
