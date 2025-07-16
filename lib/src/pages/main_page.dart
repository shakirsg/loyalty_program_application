import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/home_page.dart';
import 'package:loyalty_program_application/src/pages/profile_page.dart';
import 'package:loyalty_program_application/src/pages/rewards_page.dart';
import 'package:loyalty_program_application/src/pages/scanner_page.dart';
import 'package:loyalty_program_application/src/providers/navigation_provider.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:loyalty_program_application/src/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool _isLoading = false;

  final List<Widget> _pages = const [
    HomePage(),
    RewardsPage(),
    ScannerPage(),
    ProfilePage(),
  ];

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
      userProvider.fetchCategoryList();
    } catch (_) {
      // Optional: log error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationProvider>().selectedIndex;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: _pages[currentIndex],
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) =>
                  context.read<NavigationProvider>().setIndex(index),
            ),
          );
  }
}
