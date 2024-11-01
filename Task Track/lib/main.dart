import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(TaskTrackApp());
}

class TaskTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
