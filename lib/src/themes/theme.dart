// src/themes/theme.dart
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue, // Primary color for your app
  scaffoldBackgroundColor: Colors.white, // Set the default background color
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(
      Color(0xFFF05024),
    ), // Color of the check mark when checked
    fillColor: MaterialStateProperty.all(
      Colors.white,
    ), // Background color for the checkbox when unchecked
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4), // Custom border radius
    ),
   
  ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey), // Customize the label color
    prefixIconColor: Color(0xFFF05024), // Customize the color of the icons
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFF05024), // Outline border color
      ),
      borderRadius: BorderRadius.circular(
        12.0,
      ), // Set the radius of the input field
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(
          0xFFB0BEC5,
        ), // Border color when the field is enabled but not focused
      ),
      borderRadius: BorderRadius.circular(12.0), // Radius for enabled state
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFF05024), // Border color when the field is focused
      ),
      borderRadius: BorderRadius.circular(12.0), // Radius for focused state
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFFF05024),
    ), // Link color for TextButton
  ),
  visualDensity: VisualDensity
      .adaptivePlatformDensity, // Adjusts for different screen densities
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Default body text style
    bodyMedium: TextStyle(color: Colors.black54), // Secondary body text style
    titleLarge: TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    ), // Headline style (used in AppBar)
  ),

  appBarTheme: AppBarTheme(
    color: Color(0xFFF05024), // AppBar color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ), // AppBar title style
  ),
  // Define additional theme settings if required
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFFF05024), // Primary button color
    textTheme: ButtonTextTheme.primary, // Text style for buttons
  ),
  // Define Button Theme here
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFFF05024), // Button text color
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // Background of BottomNavBar
    selectedItemColor: Color(0xFFF05024), // Color for selected icon
    unselectedItemColor: Colors.grey, // Color for unselected icon
    selectedIconTheme: const IconThemeData(
      size: 32,
    ), // Bigger size for selected icon
    unselectedIconTheme: const IconThemeData(
      size: 24,
    ), // Smaller size for unselected icon
    elevation: 8, // Shadow depth of the BottomNavBar
  ),
);
