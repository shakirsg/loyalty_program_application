import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/home_page.dart';
import 'package:loyalty_program_application/src//widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:loyalty_program_application/src/pages/profile_page.dart';
import 'package:loyalty_program_application/src/pages/rewards_page.dart';
import 'package:loyalty_program_application/src/pages/scanner_page.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

// Create a GlobalKey for MainPage
final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  Future<void> _initializeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await Future.wait([
        authProvider.getUserProfile(),
        userProvider.getUserPoints(),
      ]);
    } catch (e) {
      // Optional: handle or log error
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavBar(
              currentIndex: _selectedIndex,
              onTap: onItemTapped,
            ),
            // backgroundColor: Colors.transparent, // Make the background transparent
          );
  }
}
