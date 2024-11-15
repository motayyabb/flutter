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
  double height = 170; // Default height value in cm
  int weight = 60; // Default weight value in kg

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
                      onPressed: handleMalePress,
                    ),
                  ),
                  Expanded(
                    child: RepeatContainerCode(
                      text: 'Female',
                      color: selectedGender == Gender.female
                          ? Colors.pink
                          : Colors.grey[800]!,
                      icon: femaleIcon,
                      onPressed: handleFemalePress,
                    ),
                  ),
                ],
              ),
            ),

            // Middle Widget (Height with Slider)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[700]!, width: 1),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Height",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          height.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " cm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: height,
                      min: 100.0,
                      max: 220.0,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Row
            Expanded(
              child: Row(
                children: [
                  // Left Bottom Widget (Weight Management)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[700]!, width: 1),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Weight",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$weight kg",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    weight = weight > 0 ? weight - 1 : 0;
                                  });
                                },
                                icon: Icon(Icons.remove, color: Colors.white),
                                iconSize: 30,
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    weight++;
                                  });
                                },
                                icon: Icon(Icons.add, color: Colors.white),
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Bottom Widget (Placeholder)
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
