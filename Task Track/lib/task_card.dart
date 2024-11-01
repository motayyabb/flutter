import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: Text(task.description),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            // Update task completion status
            task.isCompleted = value!;
            // Call update method from DatabaseHelper
          },
        ),
      ),
    );
  }
}
