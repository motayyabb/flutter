import 'package:flutter/material.dart';
import 'database_helper.dart';

class RepeatedTaskScreen extends StatefulWidget {
  @override
  _RepeatedTaskScreenState createState() => _RepeatedTaskScreenState();
}

class _RepeatedTaskScreenState extends State<RepeatedTaskScreen> {
  late Future<List<Map<String, dynamic>>> _repeatedTasks;

  @override
  void initState() {
    super.initState();
    _repeatedTasks = DatabaseHelper().getRepeatedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Repeated Tasks')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _repeatedTasks,
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
                      _repeatedTasks = DatabaseHelper().getRepeatedTasks();
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
