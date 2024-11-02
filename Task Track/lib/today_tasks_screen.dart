// today_tasks_screen.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';

class TodayTasksScreen extends StatefulWidget {
  @override
  _TodayTasksScreenState createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _todayTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTodayTasks();
  }

  void _fetchTodayTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getTodayTasks();
    setState(() {
      _todayTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Tasks'),
      ),
      body: ListView.builder(
        itemCount: _todayTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_todayTasks[index]['title']),
          );
        },
      ),
    );
  }
}
