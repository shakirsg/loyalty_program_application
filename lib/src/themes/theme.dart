// src/themes/theme.dart
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue, // Primary color for your app
  scaffoldBackgroundColor: const Color(
    0xFFEFEFEF,
  ), // Global scaffold background
  checkboxTheme: CheckboxThemeData(
    checkColor: WidgetStateProperty.all(
      Color(0xFFF05024),
    ), // Color of the check mark when checked
    fillColor: WidgetStateProperty.all(
      Colors.white,
    ), // Background color for the checkbox when unchecked
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4), // Custom border radius
    ),
    side: const BorderSide(color: Color(0xFFF05024), width: 2),
  ),
  tabBarTheme: TabBarThemeData(
    labelStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 216, 214, 214),
    ),
    labelColor: Colors.white,
    unselectedLabelColor: const Color.fromARGB(255, 216, 214, 214),
    indicatorSize: TabBarIndicatorSize.tab,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    // Add other styles as needed
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),

  cardTheme: CardThemeData(
    color: Colors.white, // Background color of the card
    shadowColor: Colors.black.withOpacity(0.2), // Shadow color
    elevation: 4, // Elevation of the card
    margin: EdgeInsets.all(8), // Margin around the card
    shape: RoundedRectangleBorder(
      // Shape of the card
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.grey),
    prefixIconColor: const Color(0xFFF05024),
    filled: true, // Enable background fill
    fillColor: Colors.white, // Set background color to white
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),

    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF05024)),
      borderRadius: BorderRadius.circular(12.0),
    ),

    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFB0BEC5)),
      borderRadius: BorderRadius.circular(12.0),
    ),

    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF05024), width: 2),
      borderRadius: BorderRadius.circular(12.0),
    ),

    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(12.0),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(12.0),
    ),
    errorStyle: const TextStyle(
      height: 1.2, // Controls error text height to avoid border overlap
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFFF05024),
    ), // Link color for TextButton
  ),
  visualDensity: VisualDensity
      .adaptivePlatformDensity, // Adjusts for different screen densities

  appBarTheme: AppBarTheme(
    color: Color(0xFFF05024), // AppBar color
    iconTheme: IconThemeData(
      color: Colors.deepPurple, // Changes back arrow color
      size: 28, // Changes back arrow size
    ),
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
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black, // Text & icon color
      side: BorderSide(color: Color(0xFFF05024), width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
