import 'dart:math';
import 'package:flutter/material.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({super.key});

  @override
  State<LoginPage1> createState() => _LoginPageState();
}

enum ButtonState { idle, animating, loading, expanding }

class _LoginPageState extends State<LoginPage1> with TickerProviderStateMixin {
  ButtonState _state = ButtonState.idle;

  late AnimationController _shrinkController;
  late AnimationController _expandController;
  late AnimationController _fadeController;

  late Animation<double> _widthAnimation;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  // Custom size settings
  final double customMaxWidth = 2000; // Set custom max width for the circle
  final double customMaxHeight = 2000; // Set custom max height for the circle

  @override
  void initState() {
    super.initState();

    _shrinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _widthAnimation = Tween<double>(begin: 280, end: 60).animate(
      CurvedAnimation(parent: _shrinkController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _expandController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _shrinkController.dispose();
    _expandController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startProcess() async {
    setState(() => _state = ButtonState.animating);
    await _shrinkController.forward();

    setState(() => _state = ButtonState.loading);

    // Simulate API login
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _state = ButtonState.expanding);
    await _expandController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Set up the expand animation with custom max width and height
    _expandAnimation = Tween<double>(begin: 60, end: max(customMaxWidth, customMaxHeight))
        .animate(CurvedAnimation(parent: _expandController, curve: Curves.easeOutExpo));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Expanding background with transparent inner circle (hole effect)
          if (_state == ButtonState.expanding || _fadeController.isCompleted)
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 - _expandAnimation.value / 2,
                  top: MediaQuery.of(context).size.height / 2 - _expandAnimation.value / 2,
                  child: ClipOval(
                    child: SizedBox(
                      width: _expandAnimation.value,
                      height: _expandAnimation.value,
                      child: Stack(
                        children: [
                          // Blue outer circle
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.blue),
                            ),
                          ),
                          // Transparent inner circle
                          Positioned.fill(
                            child: ClipOval(
                              child: Container(
                                color: Colors.transparent,
                                child: const Center(child: HomePage()), // Homepage visible through hole
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // 2. Fade in new screen (HomePage)
          if (_state == ButtonState.expanding || _fadeController.isCompleted)
            FadeTransition(opacity: _fadeAnimation, child: const HomePage()),

          // 3. Login Button (only show if not expanding)
          if (_state == ButtonState.idle || _state == ButtonState.loading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _widthAnimation,
                    builder: (context, child) {
                      return InkWell(
                        onTap: _state == ButtonState.idle ? _startProcess : null,
                        child: Container(
                          width: _widthAnimation.value,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(
                              _widthAnimation.value > 100 ? 12 : 30,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _state == ButtonState.loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // 4. Other buttons below the login button - hidden during animation
                  if (_state == ButtonState.idle || _state == ButtonState.loading)
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle other button press here
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text('Sign Up'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle forgot password button press here
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text('Forgot Password'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Final screen shown after login
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text(
          'Welcome to Mfundi Points!',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
