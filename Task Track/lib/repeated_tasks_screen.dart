import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';

class RepeatedTasksScreen extends StatefulWidget {
  @override
  _RepeatedTasksScreenState createState() => _RepeatedTasksScreenState();
}

class _RepeatedTasksScreenState extends State<RepeatedTasksScreen> {
  late Future<List<Task>> repeatedTasks;

  @override
  void initState() {
    super.initState();
    repeatedTasks = DatabaseHelper().getTasks(); // Fetch repeated tasks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repeated Tasks"),
      ),
      body: FutureBuilder<List<Task>>(
        future: repeatedTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text("No repeated tasks."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              if (task.isRepeated) {
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
