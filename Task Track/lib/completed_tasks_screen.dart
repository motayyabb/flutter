import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';

class CompletedTasksScreen extends StatefulWidget {
  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  late Future<List<Task>> completedTasks;

  @override
  void initState() {
    super.initState();
    completedTasks = DatabaseHelper().getTasks(); // Fetch completed tasks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Tasks"),
      ),
      body: FutureBuilder<List<Task>>(
        future: completedTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text("No completed tasks."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              if (task.isCompleted) {
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
