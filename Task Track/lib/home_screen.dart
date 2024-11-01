import 'package:flutter/material.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    List<Map<String, dynamic>> tasks = await _databaseHelper.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _addTask(Map<String, dynamic> taskData) async {
    await _databaseHelper.insertTask(
      taskData['title'],
      taskData['description'],
      taskData['isRepeated'],
      taskData['isCompleted'],
      taskData['date'],
      taskData['time'],
    );
    _fetchTasks();
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Task Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Task Description'),
                  maxLines: 2,
                ),
                ListTile(
                  title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text("Time: ${selectedTime.format(context)}"),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null && picked != selectedTime) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _addTask({
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'isRepeated': false,
                    'isCompleted': false,
                    'date': selectedDate.toIso8601String(),
                    'time': TimeOfDay.now().format(context),
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(int id, String currentTitle, String currentDescription, String currentDate, String currentTime) {
    final TextEditingController titleController = TextEditingController(text: currentTitle);
    final TextEditingController descriptionController = TextEditingController(text: currentDescription);
    DateTime selectedDate = DateTime.parse(currentDate);
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.parse(currentTime));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Task Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Task Description'),
                  maxLines: 2,
                ),
                ListTile(
                  title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text("Time: ${selectedTime.format(context)}"),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null && picked != selectedTime) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _databaseHelper.updateTask(id, titleController.text, descriptionController.text, false, false, selectedDate.toIso8601String(), selectedTime.format(context));
                  _fetchTasks();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int id) async {
    await _databaseHelper.deleteTask(id);
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Tasks'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(_tasks[index]['title']),
              subtitle: Text(_tasks[index]['description'] ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditTaskDialog(
                        _tasks[index]['id'], _tasks[index]['title'], _tasks[index]['description'], _tasks[index]['date'], _tasks[index]['time']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTask(_tasks[index]['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
