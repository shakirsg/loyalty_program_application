import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/redeem_reward_page.dart';
import 'package:http/http.dart' as http;
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  String _selectedCategory = 'All'; // Default category

  String? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // fetchData();
    // Trigger API call when HomePage loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(
        context,
        listen: false,
      ).loadUserProfile("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null, // no back button on root page
        title: Text('Rewards Catalog'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFFF05024),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rewards Catalog',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final userData = userProvider.userData;
                      final totalPoints = userData != null
                          ? userData['total'].toString()
                          : 'your';

                      return Text(
                        'Redeem $totalPoints points for rewards',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Main Panel
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(),
                            filled: true, // Enable filled background
                            fillColor: Colors
                                .white, // Set the background color to white
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 40, // Square button size
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search, color: Color(0xFFF05024)),
                          onPressed: () {
                            // Handle search logic
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Search Categories (Scroll-x)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _categoryButton('All'),
                        _categoryButton('Food'),
                        _categoryButton('Electronics'),
                        _categoryButton('Fashion'),
                        _categoryButton('Clock'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Available Rewards Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Rewards',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '500 pts available',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // First Reward Card
                  _rewardCard(
                    imageUrl: './assets/coffee.png', // Use real image URL
                    title: 'Free Coffee',
                    description: 'Get a free coffee at any participating store',
                    points: '200',
                  ),
                  SizedBox(height: 20),

                  // Second Reward Card
                  _rewardCard(
                    imageUrl: './assets/carousel_3.png', // Use real image URL
                    title: '15% Discount',
                    description: '15% off your next purchase',
                    points: '300',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category Button Widget
  Widget _categoryButton(String label) {
    bool isSelected = _selectedCategory == label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = label; // Update selected category
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Color(0xFFF05024)
              : Colors.white, // Change color based on selection
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: BorderSide(
            color: Color(0xFFF05024), // Border color for unselected buttons
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected
                ? Colors.white
                : Color(0xFFF05024), // Change text color based on selection
          ),
        ),
      ),
    );
  }

  // Reward Card Widget
  // Inside _rewardCard
  Widget _rewardCard({
    required String imageUrl,
    required String title,
    required String description,
    required String points,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(description),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to RedeemRewardPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RedeemRewardPage(
                              imageUrl: imageUrl,
                              title: title,
                              description: description,
                              points: points,
                            ),
                          ),
                        );
                      },
                      child: Text('Redeem Reward'),
                    ),
                    Text(
                      '$points pts',
                      style: TextStyle(fontSize: 16, color: Colors.red),
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
