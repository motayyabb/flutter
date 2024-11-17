import 'package:flutter/material.dart';
import 'repeat_container_code.dart';
import 'icon_constants.dart';
import 'result_screen.dart';

// Enum for Gender
enum Gender { male, female }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BMI Calculator',
          theme: isDarkMode
              ? ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          )
              : ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.black),
            ),
          ),
          home: HomeScreen(),
        );
      },
    );
  }
}

class ThemeNotifier {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(true);

  static void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Gender? selectedGender;
  double height = 170; // Default height in cm
  int weight = 60; // Default weight in kg
  int age = 25; // Default age

  void handleMalePress() {
    setState(() {
      selectedGender = Gender.male;
    });
  }

  void handleFemalePress() {
    setState(() {
      selectedGender = Gender.female;
    });
  }

  void navigateToResultScreen() {
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a gender")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          gender: selectedGender!,
          height: height,
          weight: weight,
          age: age,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI Calculator',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              ThemeNotifier.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            onPressed: () {
              ThemeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                children: [
                  // Gender Selection
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: RepeatContainerCode(
                            text: 'Male',
                            color: selectedGender == Gender.male
                                ? Colors.blue
                                : Theme.of(context).primaryColor.withOpacity(0.1),
                            icon: maleIcon,
                            onPressed: handleMalePress,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RepeatContainerCode(
                            text: 'Female',
                            color: selectedGender == Gender.female
                                ? Colors.pink
                                : Theme.of(context).primaryColor.withOpacity(0.1),
                            icon: femaleIcon,
                            onPressed: handleFemalePress,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Height Slider
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Height",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
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
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " cm",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
                            inactiveColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey
                                : Colors.black26,
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
                  const SizedBox(height: 12),

                  // Weight and Age Widgets
                  Expanded(
                    child: Row(
                      children: [
                        // Weight Widget
                        Expanded(
                          child: RepeatContainerCode(
                            text: "Weight",
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Weight",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$weight kg",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FloatingActionButton(
                                      heroTag: "weight-decrement",
                                      onPressed: () {
                                        setState(() {
                                          weight = weight > 0 ? weight - 1 : 0;
                                        });
                                      },
                                      mini: true,
                                      backgroundColor: Colors.grey[700],
                                      child: const Icon(Icons.remove, color: Colors.white),
                                    ),
                                    FloatingActionButton(
                                      heroTag: "weight-increment",
                                      onPressed: () {
                                        setState(() {
                                          weight++;
                                        });
                                      },
                                      mini: true,
                                      backgroundColor: Colors.grey[700],
                                      child: const Icon(Icons.add, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Age Widget
                        Expanded(
                          child: RepeatContainerCode(
                            text: "Age",
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Age",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$age",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FloatingActionButton(
                                      heroTag: "age-decrement",
                                      onPressed: () {
                                        setState(() {
                                          age = age > 0 ? age - 1 : 0;
                                        });
                                      },
                                      mini: true,
                                      backgroundColor: Colors.grey[700],
                                      child: const Icon(Icons.remove, color: Colors.white),
                                    ),
                                    FloatingActionButton(
                                      heroTag: "age-increment",
                                      onPressed: () {
                                        setState(() {
                                          age++;
                                        });
                                      },
                                      mini: true,
                                      backgroundColor: Colors.grey[700],
                                      child: const Icon(Icons.add, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Calculate Button
          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: navigateToResultScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Calculate BMI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
