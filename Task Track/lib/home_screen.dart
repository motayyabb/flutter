import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'completed_tasks_screen.dart';
import 'repeated_tasks_screen.dart';
import 'today_tasks_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Start with "Today's Tasks" selected
  final List<Widget> _screens = [
    TodayTasksScreen(),
    CompletedTasksScreen(),
    AddTaskScreen(),
    RepeatedTasksScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Change the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Rounded top corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, -3), // Shadow on the top of the bar
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 40), // Larger icon for Add Task
              label: 'Add Task',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.replay),
              label: 'Repeated',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped, // Call the function to handle navigation
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14, // Custom font size
          unselectedFontSize: 12, // Custom font size
          backgroundColor: Colors.white, // Background color
          elevation: 5, // Shadow elevation
        ),
      ),
    );
  }
}
