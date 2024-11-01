import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';

class TodayTaskScreen extends StatefulWidget {
  @override
  _TodayTaskScreenState createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = DatabaseHelper().getTasks(); // Fetch tasks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Tasks"),
      ),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text("No tasks for today."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) async {
                    task.isCompleted = value!;
                    await DatabaseHelper().updateTask(task);
                    setState(() {});
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
