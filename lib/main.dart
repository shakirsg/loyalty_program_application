import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/config/route.dart';
import 'src/themes/theme.dart';
import 'src/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyalty App',
      theme: lightTheme, // Apply theme here

      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: appRoutes,
    );
  }
}
