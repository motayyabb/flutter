import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black54),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
  );

  static final dark = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey[850],
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white54),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
  );
}
