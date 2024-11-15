import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        brightness: Brightness.dark, // Sets the app theme to dark
        primaryColor: Colors.blue, // AppBar background color
        scaffoldBackgroundColor: Colors.black, // Background color of the app
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Default text color
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI Calculator',
          style: TextStyle(color: Colors.white), // Title text color
        ),
        backgroundColor: Colors.black, // AppBar background color
        centerTitle: true, // Centers the title
      ),
      body: Center(
        child: Text(
          'Welcome to the BMI Calculator App!',
          style: TextStyle(
            fontSize: 20, // Text size
            fontWeight: FontWeight.bold, // Text boldness
            color: Colors.white, // Text color
          ),
        ),
      ),
    );
  }
}
