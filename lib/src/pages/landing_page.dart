import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/cards/CardWidget.dart'; // Import the CardWidget

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> imageUrls = const [
    'assets/carousel_1.png',
    'assets/carousel_2.png',
    'assets/carousel_3.png',
  ];

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty')),
      body: Stack(
        children: [
          // Main Carousel Container
          Column(
            children: [
              Expanded(
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: double.infinity, // Take up remaining space
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: imageUrls.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CardWidget(imageUrl: url); // Use the CardWidget here
                      },
                    );
                  }).toList(),
                ),
              ),
              // Carousel Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageUrls.asMap().entries.map((entry) {
                  bool isActive = _currentIndex == entry.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 48.0 : 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color.fromARGB(255, 235, 86, 49)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }).toList(),
              ),
              // Next Slide or Get Started Button at the bottom
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentIndex == imageUrls.length - 1) {
                        // Navigate to MainPage when "Get Started" is clicked
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        _carouselController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      }
                    },
                    child: Text(
                      _currentIndex == imageUrls.length - 1
                          ? 'Get Started'
                          : 'Next Slide',
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Skip Button on the Top Right
          Positioned(
            top: 20,
            right: 20,
            child: TextButton(
              onPressed: () {
                // Navigate to the login screen or main page immediately
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
