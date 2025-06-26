import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/landing_page.dart';
import '../pages/main_page.dart'; // <== import
import '../pages/register_page.dart'; // 
import '../pages/test_page.dart'; // 


final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(), // ✅ Add this
  '/landing': (context) => const LandingPage(),
  '/main': (context) => const MainPage(),
  '/test': (context) => const LoginPage1(),

};
