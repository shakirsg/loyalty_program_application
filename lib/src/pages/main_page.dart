import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/home_page.dart';
import 'package:loyalty_program_application/src//widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:loyalty_program_application/src/pages/profile_page.dart';
import 'package:loyalty_program_application/src/pages/rewards_page.dart';
import 'package:loyalty_program_application/src/pages/scanner_page.dart';

// Create a GlobalKey for MainPage
final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const RewardsPage(),
    const ScannerPage(),
    const ProfilePage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
      // backgroundColor: Colors.transparent, // Make the background transparent
    );
  }
}
