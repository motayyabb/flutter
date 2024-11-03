import 'package:flutter/material.dart';
import 'database_helper.dart';

class TodayTaskScreen extends StatefulWidget {
  @override
  _TodayTaskScreenState createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  late Future<List<Map<String, dynamic>>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = DatabaseHelper().getTodayTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today\'s Tasks')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tasks,
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
                  icon: Icon(Icons.check),
                  onPressed: () {
                    DatabaseHelper().updateTask(task['id'], {'isCompleted': 1});
                    setState(() {
                      _tasks = DatabaseHelper().getTodayTasks();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    dueDate = selectedDate;
                  }
                },
                child: Text('Select Due Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newTask = {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'dueDate': dueDate?.toIso8601String().substring(0, 10), // Format to YYYY-MM-DD
                  'isCompleted': 0,
                  'repeatInterval': null,
                };
                DatabaseHelper().insertTask(newTask);
                Navigator.of(context).pop();
                setState(() {
                  _tasks = DatabaseHelper().getTodayTasks();
                });
              },
              child: Text('Add Task'),
            ),
          ],
        );
      },
    );
  }
}
