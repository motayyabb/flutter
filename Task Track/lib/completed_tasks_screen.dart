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
    List<Map<String, dynamic>> tasks = await _databaseHelper.getCompletedTasks();
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
      body: _completedTasks.isEmpty
          ? Center(child: Text('No completed tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : ListView.builder(
        itemCount: _completedTasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(
                _completedTasks[index]['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                _completedTasks[index]['description'] ?? '',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          );
        },
      ),
    );
  }
}
