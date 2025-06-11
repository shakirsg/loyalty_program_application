// src/themes/theme.dart
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue, // Primary color for your app
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
    color: Colors.red, // AppBar color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ), // AppBar title style
  ),
  // Define additional theme settings if required
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.red, // Primary button color
    textTheme: ButtonTextTheme.primary, // Text style for buttons
  ),
  // Define Button Theme here
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: Colors.red, // Button text color
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
);
