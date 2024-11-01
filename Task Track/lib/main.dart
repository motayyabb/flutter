import 'package:flutter/material.dart';
import 'database_helper.dart'; // Adjust this import based on your file structure
import 'home_screen.dart'; // Ensure this is the correct path to your HomeScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
