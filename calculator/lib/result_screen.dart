import 'package:flutter/material.dart';
import 'main.dart'; // To use the Gender enum

class ResultScreen extends StatelessWidget {
  final Gender gender;
  final double height;
  final int weight;
  final int age;

  ResultScreen({
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate BMI
    double bmi = weight / ((height / 100) * (height / 100));

    // Determine BMI category
    String bmiCategory;
    String bmiDescription;

    if (gender == Gender.male) {
      if (bmi < 18.5) {
        bmiCategory = "Underweight";
        bmiDescription = "You are underweight for a male. Consider a balanced diet.";
      } else if (bmi < 25) {
        bmiCategory = "Normal";
        bmiDescription = "Your BMI is normal. Keep it up!";
      } else if (bmi < 30) {
        bmiCategory = "Overweight";
        bmiDescription = "You are slightly overweight for a male. Try to exercise more.";
      } else {
        bmiCategory = "Obese";
        bmiDescription = "You are in the obese range. Consult with a doctor.";
      }
    } else if (gender == Gender.female) {
      if (bmi < 18.5) {
        bmiCategory = "Underweight";
        bmiDescription = "You are underweight for a female. Consider a balanced diet.";
      } else if (bmi < 25) {
        bmiCategory = "Normal";
        bmiDescription = "Your BMI is normal. Keep it up!";
      } else if (bmi < 30) {
        bmiCategory = "Overweight";
        bmiDescription = "You are slightly overweight for a female. Try to exercise more.";
      } else {
        bmiCategory = "Obese";
        bmiDescription = "You are in the obese range. Consult with a doctor.";
      }
    } else {
      bmiCategory = "Unknown";
      bmiDescription = "Gender not recognized. Please specify a valid gender.";
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Result',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              "Your Result",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            // BMI Value
            Column(
              children: [
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bmiCategory,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // BMI Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                bmiDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ),

            // Recalculate Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                "Recalculate",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
