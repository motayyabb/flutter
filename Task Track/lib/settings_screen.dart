import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool? value) {
    setState(() {
      _isDarkMode = value ?? false;
    });
    // You can add logic to persist the theme choice
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Toggle Dark Mode:'),
            Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}
