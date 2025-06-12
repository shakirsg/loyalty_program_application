import 'package:flutter/material.dart';
import 'src/config/route.dart';
import 'src/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyalty App',
      theme: lightTheme, // Apply theme here

      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      routes: appRoutes,
    );
  }
}
