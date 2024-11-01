import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _dueDate = '';

  void _addTask() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      Task newTask = Task(
        title: title,
        description: description,
        dueDate: _dueDate,
      );

      await DatabaseHelper().insertTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dueDate = pickedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Due Date",
                hintText: _dueDate.isEmpty ? "Select a date" : _dueDate,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              child: Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
