import 'package:flutter/material.dart';

class CoffeeIntroPage extends StatelessWidget {
  const CoffeeIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              // Background Image
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.68,
                child: Image.asset(
                  'assets/image-3.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Gradient Overlay
              Positioned(
                top: screenHeight * 0.55,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.45,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                      stops: [0.0, 0.23],
                    ),
                  ),
                ),
              ),

              // Main Text
              Positioned(
                top: screenHeight * 0.61,
                left: 24,
                right: 24,
                child: Text(
                  'Coffee so good, your taste buds will love it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Sora',
                  ),
                ),
              ),

              // Sub Text
              Positioned(
                top: screenHeight * 0.80,
                left: 24,
                right: 24,
                child: Text(
                  'The best grain, the finest roast, the powerful flavor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: Colors.grey[400],
                    fontFamily: 'Sora',
                  ),
                ),
              ),

              // Google Button
              Positioned(
                bottom: screenHeight * 0.03,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4A000000),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo-googleg-48dp.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
