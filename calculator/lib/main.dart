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
                        icon: Icons.male, // Built-in Material Icon for Male
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RepeatContainerCode(
                        text: 'Female',
                        color: Colors.grey[800]!,
                        icon: Icons.female, // Built-in Material Icon for Female
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

class RepeatContainerCode extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon; // Optional icon property

  const RepeatContainerCode({
    Key? key,
    required this.text,
    required this.color,
    this.icon, // Optional parameter for the icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          SizedBox(height: 10), // Space between icon and text
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
