import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/components/QuickActionCard.dart';
import 'package:loyalty_program_application/src/components/PointsCard.dart';
import 'package:loyalty_program_application/src/components/RecentActivityCard.dart';
import 'package:loyalty_program_application/src/components/StatusCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      backgroundColor: const Color(0xFFEFEFEF),
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
              cardCount: 2,
              cards: [
                QuickActionCard(icon: Icons.qr_code, title: 'Scan Product'),
                QuickActionCard(
                  icon: Icons.card_giftcard,
                  title: 'Redeem Points',
                ),
              ],
            ),

            // Third Section: Stats
            SectionCard(
              title: 'Stats',
              cardCount: 2,
              cards: [
                StatusCard(
                  icon: Icons.monetization_on,
                  title: 'Total earned!',
                  description: '750 pts',
                ),
                StatusCard(
                  icon: Icons.history,
                  title: 'This month',
                  description: '250 pts',
                ),
              ],
            ),

            // Fourth Section: Recent Activity
            SectionCard(
              title: 'Recent Activity',
              description: '',
              cardCount: 1,

              cards: [
                RecentActivityCard(
                  icon: Icons.arrow_upward,
                  title: 'Scanned Coffee Bag',
                  value: '+200 pts',
                  date: '2025-06-12',
                  location: 'New York, USA',
                  downtime: '2 hours',
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
    super.key,
    required this.title,
    this.description = '', // Default value is an empty string
    required this.cardCount,
    required this.cards,
    this.backgroundColor = const Color(0xFFEFEFEF), // Default background color
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
        padding: const EdgeInsets.all(
          16.0,
        ), // Optional padding inside the container
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
            // Only show the description if it's not empty
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: descriptionColor, // Apply description color
                ),
              ),
              const SizedBox(height: 12),
            ],
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
