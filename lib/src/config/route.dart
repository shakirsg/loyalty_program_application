import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/standing_page.dart';
import 'package:loyalty_program_application/src/pages/login_page.dart';
import 'package:loyalty_program_application/src/pages/register_page.dart';
import 'package:loyalty_program_application/src/pages/landing_page.dart';
import 'package:loyalty_program_application/src/pages/main_page.dart';
import 'package:loyalty_program_application/src/pages/test_page.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/landing': (context) => const LandingPage(),
  '/standing': (context) =>const StandingPage(),
  '/main': (context) => const MainPage(),
  '/test': (context) => const LoginPage1(),

};
