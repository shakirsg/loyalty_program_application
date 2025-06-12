import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/components/PointsCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: Column(
            children: [
              // First Section: Points Plus
              SectionCard(
                title: 'Points Plus',
                titleColor: Colors.white,
                description: 'Welcome back, Alex',
                descriptionColor: Colors.white,
                cardCount: 1,
                cards: [PointsCard()],
                backgroundColor: Color(0xFFF05024), // Example background color
              ),

              // Second Section: Quick Actions
              SectionCard(
                title: 'Quick Actions',
                description: 'Take a quick action from here.',
                cardCount: 2,
                cards: [
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Card 1',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Card 2',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Third Section: Stats
              SectionCard(
                title: 'Stats',
                description: 'Check your performance stats.',
                cardCount: 2,
                cards: [
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'Card 1',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'Card 2',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Fourth Section: Recent Activity
              SectionCard(
                title: 'Recent Activity',
                description: 'See your latest actions.',
                cardCount: 1,
                cards: [
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      height: 90,
                      child: Center(
                        child: Text(
                          'Card 1',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String description;
  final int cardCount;
  final List<Widget> cards;
  final Color backgroundColor; // Background color prop
  final Color titleColor; // Title color prop
  final Color descriptionColor; // Description color prop
  final double bottomRadius; // Bottom radius prop

  const SectionCard({
    required this.title,
    required this.description,
    required this.cardCount,
    required this.cards,
    this.backgroundColor = Colors.white, // Default background color
    this.titleColor = Colors.black, // Default title color
    this.descriptionColor = Colors.grey, // Default description color
    this.bottomRadius = 25.0, // Default bottom radius
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Apply the background color
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomRadius), // Bottom-left radius
            bottomRight: Radius.circular(bottomRadius), // Bottom-right radius
          ),
        ),
        padding: const EdgeInsets.all(16.0), // Optional padding inside the container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor, // Apply title color
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: descriptionColor, // Apply description color
              ),
            ),
            const SizedBox(height: 12),
            // Using Row with Expanded and flex for responsive cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(cardCount, (index) {
                return Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: cards.isNotEmpty ? cards[index] : SizedBox.shrink(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
