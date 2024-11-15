import 'package:flutter/material.dart';
import 'repeat_container_code.dart';
import 'icon_constants.dart';

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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selected = ""; // Holds the currently selected gender

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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = "Male"; // Update the selected value
                        });
                      },
                      child: RepeatContainerCode(
                        text: 'Male',
                        color: selected == "Male"
                            ? Colors.blue // Change color if selected
                            : Colors.grey[850]!,
                        icon: maleIcon,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = "Female"; // Update the selected value
                        });
                      },
                      child: RepeatContainerCode(
                        text: 'Female',
                        color: selected == "Female"
                            ? Colors.pink // Change color if selected
                            : Colors.grey[800]!,
                        icon: femaleIcon,
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
