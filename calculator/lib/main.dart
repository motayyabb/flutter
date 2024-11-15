import 'package:flutter/material.dart';
import 'repeat_container_code.dart';
import 'icon_constants.dart';

// Enum for Gender
enum Gender { male, female }

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
  Gender? selectedGender; // Holds the currently selected gender

  void handleMalePress() {
    setState(() {
      selectedGender = Gender.male;
    });
    print("Male selected!");
  }

  void handleFemalePress() {
    setState(() {
      selectedGender = Gender.female;
    });
    print("Female selected!");
  }

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Top Row
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RepeatContainerCode(
                      text: 'Male',
                      color: selectedGender == Gender.male
                          ? Colors.blue
                          : Colors.grey[850]!,
                      icon: maleIcon,
                      onPressed: handleMalePress, // Call male handler
                    ),
                  ),
                  Expanded(
                    child: RepeatContainerCode(
                      text: 'Female',
                      color: selectedGender == Gender.female
                          ? Colors.pink
                          : Colors.grey[800]!,
                      icon: femaleIcon,
                      onPressed: handleFemalePress, // Call female handler
                    ),
                  ),
                ],
              ),
            ),

            // Middle Widget (Dynamic Message)
            Expanded(
              child: RepeatContainerCode(
                text: selectedGender == Gender.male
                    ? 'You selected Male'
                    : selectedGender == Gender.female
                    ? 'You selected Female'
                    : 'Make a Selection',
                color: selectedGender == null
                    ? Colors.grey[850]!
                    : Colors.grey[700]!,
              ),
            ),

            // Bottom Row
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RepeatContainerCode(
                      text: 'Bottom Left',
                      color: Colors.grey[800]!,
                      onPressed: () {
                        print("Bottom Left Pressed");
                      },
                    ),
                  ),
                  Expanded(
                    child: RepeatContainerCode(
                      text: 'Bottom Right',
                      color: Colors.grey[850]!,
                      onPressed: () {
                        print("Bottom Right Pressed");
                      },
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
