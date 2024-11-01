import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String title = '';
  String description = '';
  String dueDate = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        dueDate = "${picked.toLocal()}".split(' ')[0]; // Format date as needed
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Task Title", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter task title',
              ),
            ),
            SizedBox(height: 20),
            Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: (value) {
                description = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter task description',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dueDate.isEmpty ? 'Select Due Date' : dueDate, style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date', style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && dueDate.isNotEmpty) {
                  dbHelper.insertTask(Task(
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    isCompleted: false,
                    isRepeated: false,
                  ));
                  Navigator.pop(context, true); // Return to home screen with success
                }
              },
              child: Text('Add Task'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
