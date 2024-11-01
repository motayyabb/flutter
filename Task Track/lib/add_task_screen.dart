import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _dueDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                onSaved: (value) => _dueDate = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a due date' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await DatabaseHelper().insertTask(Task(title: _title, description: _description, dueDate: _dueDate));
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
