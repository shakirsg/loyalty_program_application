import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/home_page.dart';
import '../pages/landing_page.dart';
import '../pages/login_page.dart';
import '../widgets/BottomNavigationBar/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Cart Page')), // Placeholder
    const Center(child: Text('Search Page')), // Placeholder
    const Center(child: Text('Profile Page')), // Placeholder

  ];

  void _onItemTapped(int index) {
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
        onTap: _onItemTapped,
      ),
    );
  }
}
