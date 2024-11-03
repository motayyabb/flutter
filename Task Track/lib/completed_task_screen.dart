import 'package:flutter/material.dart';
import 'database_helper.dart';

class CompletedTaskScreen extends StatefulWidget {
  @override
  _CompletedTaskScreenState createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  late Future<List<Map<String, dynamic>>> _completedTasks;

  @override
  void initState() {
    super.initState();
    _completedTasks = DatabaseHelper().getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _completedTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DatabaseHelper().deleteTask(task['id']);
                    setState(() {
                      _completedTasks = DatabaseHelper().getCompletedTasks();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
