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
      body: _tasks.isEmpty
          ? Center(child: Text('No tasks for today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(
                _tasks[index]['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                _tasks[index]['description'] ?? '',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          );
        },
      ),
    );
  }
}
