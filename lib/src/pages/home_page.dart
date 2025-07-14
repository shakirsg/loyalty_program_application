import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/components/QuickActionCard.dart';
import 'package:loyalty_program_application/src/components/PointsCard.dart';
import 'package:loyalty_program_application/src/components/RecentActivityCard.dart';
import 'package:loyalty_program_application/src/components/StatusCard.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool _isLoading = true;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 3), () {
    //   _showImage = false;
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthProvider>(context);
    // final isLoading = provider.isLoading;
    final fullName = context.watch<AuthProvider>().fullName;

    final userProvider = Provider.of<UserProvider>(context);
    final totalEarnedPoints = userProvider.pointHistory.fold<double>(
      0.0,
      (sum, item) => sum + (item['points_available'] ?? 0.0),
    ).toInt();;

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final monthlyPoints = userProvider.pointHistory.where((item) {
      final created = DateTime.tryParse(item['created'] ?? '');
      return created != null &&
          created.month == currentMonth &&
          created.year == currentYear;
    }).fold<double>(
      0.0,
      (sum, item) => sum + (item['points_available'] ?? 0.0),
    ).toInt();;

    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Remove the image from here since it will be on top now
                // Your other sections here...
                SectionCard(
                  title: 'Points Plus',
                  titleColor: Colors.white,
                  description: 'Welcome back! $fullName',
                  descriptionColor: Colors.white,
                  cardCount: 1,
                  cards: [PointsCard()],
                  backgroundColor: Color(0xFFF05024),
                ),
                SectionCard(
                  title: 'Quick Actions',
                  cardCount: 2,
                  cards: [
                    QuickActionCard(
                      icon: Icons.qr_code,
                      title: 'Scan Product',
                      targetIndex: 2,
                    ),
                    QuickActionCard(
                      icon: Icons.card_giftcard,
                      title: 'Redeem Points',
                      targetIndex: 1,
                    ),
                  ],
                ),
                SectionCard(
                  title: 'Stats',
                  cardCount: 2,
                  cards: [
                    StatusCard(
                      icon: Icons.trending_up,
                      title: 'Total earned!',
                      description: '$totalEarnedPoints pts',
                    ),
                    StatusCard(
                      icon: Icons.history,
                      title: 'This month',
                      description: '$monthlyPoints pts',
                    ),
                  ],
                ),
                // SectionCard(
                //   title: 'Recent Activity',
                //   description: '',
                //   cardCount: 1,
                //   cards: [
                //     RecentActivityCard(
                //       icon: Icons.trending_up,
                //       title: 'Scanned Coffee Bag',
                //       value: '+200 pts',
                //       date: '2025-06-12',
                //       location: 'New York, USA',
                //       downtime: '2 hours',
                //     ),
                //   ],
                // ),
              ],
            ),
          ),

          // if (_showImage)
          //   AbsorbPointer(
          //     absorbing: true,
          //     child: Image.asset(
          //       'assets/2.webp',
          //       width: double.infinity,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
        ],
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
      padding: const EdgeInsets.only(bottom: 0.0),
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
