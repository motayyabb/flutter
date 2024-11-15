import 'package:flutter/material.dart';
import 'repeat_container_code.dart'; // Import RepeatContainerCode
import 'icon_constants.dart'; // Import Icon Constants

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
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Padding for the entire layout
        child: Column(
          children: [
            // Top Row
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RepeatContainerCode(
                        text: 'Male',
                        color: Colors.grey[850]!,
                        icon: maleIcon, // Male icon from constants
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RepeatContainerCode(
                        text: 'Female',
                        color: Colors.grey[800]!,
                        icon: femaleIcon, // Female icon from constants
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Middle Widget
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RepeatContainerCode(
                  text: 'Middle',
                  color: Colors.grey[850]!,
                ),
              ),
            ),

            // Bottom Row
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RepeatContainerCode(
                        text: 'Bottom Left',
                        color: Colors.grey[800]!,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RepeatContainerCode(
                        text: 'Bottom Right',
                        color: Colors.grey[850]!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
