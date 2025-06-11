import 'package:flutter/material.dart';
import 'src/config/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: appRoutes,
    );
  }
}
