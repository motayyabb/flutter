import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_task_screen.dart';

void main() => runApp(TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addTask': (context) => AddTaskScreen(),
      },
    );
  }
}
