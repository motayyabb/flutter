import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'repeated_tasks_screen.dart';
import 'completed_tasks_screen.dart';
import 'today_tasks_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.blue),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RepeatedTasksScreen(),
    CompletedTasksScreen(),
    TodayTasksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: 'Repeated'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
