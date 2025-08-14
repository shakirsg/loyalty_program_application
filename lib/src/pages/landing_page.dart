import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:metsec_loyalty_app/src/widgets/cards/card_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Map<String, String>> cardData = const [
    {
      'imageUrl': 'assets/carousel_2.png',
      'title': 'Scan Products to Earn Points',
      'description':
          'Use your camera to scan QR codes on participating products and instantly earn loyalty points.',
    },
    {
      'imageUrl': 'assets/carousel_3.png',
      'title': 'Redeem for Exclusive Rewards',
      'description':
          'Exchange your points for exclusive discounts, products, and experiences from our partners.',
    },
  ];

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: const Text('Loyalty')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool shouldDisplayImages =
                constraints.maxHeight > 400; // Threshold height

            return Stack(
              children: [
                // Main Carousel Container
                Column(
                  children: [
                    Expanded(
                      child: shouldDisplayImages
                          ? CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                height: constraints
                                    .maxHeight, // Use the available height
                                autoPlay: false,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                              items: cardData.map((data) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return CardWidget(
                                      imageUrl: data['imageUrl']!,
                                      title: data['title']!,
                                      description: data['description']!,
                                    );
                                  },
                                );
                              }).toList(),
                            )
                          : Container(
                              color: Colors.grey[200], // Light gray background
                              child: Center(
                                child: Icon(
                                  Icons.image, // Placeholder image icon
                                  size: 80,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                    ),
                    // Carousel Indicators
                    if (shouldDisplayImages)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: cardData.asMap().entries.map((entry) {
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
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentIndex == cardData.length - 1) {
                              // Navigate to MainPage when "Get Started" is clicked
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              _carouselController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear,
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentIndex == cardData.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                              ),
                              if (_currentIndex != cardData.length - 1)
                                Icon(
                                  Icons.arrow_forward_ios, // Right arrow icon
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Skip Button on the Top Right
                Positioned(
                  top: 40,
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
            );
          },
        ),
      ),
    );
  }
}
