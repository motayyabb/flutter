import 'package:flutter/material.dart';
import 'database_helper.dart';

class RepeatedTasksScreen extends StatefulWidget {
  @override
  _RepeatedTasksScreenState createState() => _RepeatedTasksScreenState();
}

class _RepeatedTasksScreenState extends State<RepeatedTasksScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getRepeatedTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repeated Tasks'),
      ),
      body: _tasks.isEmpty
          ? Center(child: Text('No repeated tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
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
