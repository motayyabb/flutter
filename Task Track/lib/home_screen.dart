import 'package:flutter/material.dart';
import 'completed_tasks_screen.dart';
import 'repeated_tasks_screen.dart';
import 'settings_screen.dart';
import 'today_task_screen.dart';
import 'add_task_screen.dart'; // New screen for adding tasks

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Tracker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodayTaskScreen()),
                );
              },
              child: Text("Today's Tasks"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletedTasksScreen()),
                );
              },
              child: Text("Completed Tasks"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RepeatedTasksScreen()),
                );
              },
              child: Text("Repeated Tasks"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Text("Settings"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen()), // New screen for adding tasks
                );
              },
              child: Text("Add New Task"),
            ),
          ],
        ),
      ),
    );
  }
}
