import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _saveTask() async {
    final task = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': _selectedDate?.toIso8601String(),
      'time': _selectedTime?.format(context),
      'isCompleted': 0,
    };
    await DatabaseHelper.instance.addTask(task);
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            ElevatedButton(onPressed: _selectDate, child: Text('Select Date')),
            ElevatedButton(onPressed: _selectTime, child: Text('Select Time')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveTask, child: Text('Save Task')),
          ],
        ),
      ),
    );
  }
}
