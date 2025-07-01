import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/rewards_success_page.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RedeemRewardPage extends StatelessWidget {
  final int itemId;
  final String imageUrl;
  final String title;
  final String description;
  final String points;

  // Constructor
  const RedeemRewardPage({
    super.key,
    required this.itemId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final totalPoints = context.watch<UserProvider>().total_points;
    String totalPoints_ = totalPoints.toStringAsFixed(3);
    double remaining = totalPoints - double.parse(points);
    String formatted = remaining.toStringAsFixed(3); // "83092.00"

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null, // no back button on root page
        title: Text('Redeem Reward'),
      ),
      body: ListView(
        children: [
          // Top Image Section with Title and Badge
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl), // Image of the reward
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reward Value: $points pts',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$points pts',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Description Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),

          // Reward Card with Check Icon, Title, and Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: // Inside your build method, replace the old card with this:
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Title
                        Text(
                          'Redeem Process',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Item 1
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFFF05024),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Step 1: Confirm reward availability',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Item 2
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFFF05024),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Step 2: Ensure you have enough points',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Item 3
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFFF05024),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Step 3: Redeem and receive confirmation',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Balance Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('$totalPoints_ pts'), // Replace with current balance
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'After Redeem',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('$formatted pts'), // Replace with after redeem balance
                  ],
                ),
              ],
            ),
          ),

          // Redeem Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // final intPoints = int.tryParse(formatted.toString()) ?? 0;

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (remaining < 0) {
                      return AlertDialog(
                        title: const Text(
                          'Info',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Need more reward points. Cannot redeem the reward.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    } else {
                      // Else show confirmation dialog
                      return AlertDialog(
                        backgroundColor: const Color(0xFFFFF5F3),
                        title: const Text(
                          'Confirm Redemption',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Are you sure you want to redeem this reward for $points pts?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await userProvider.redeemRewardById(itemId);
                              await userProvider.getUserPoints();
                              Navigator.of(context).pop();

                              final redeemResult = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).redeemResult;
                              if (redeemResult is Map<String, dynamic>) {
                                if (redeemResult.containsKey('error')) {
                                  // ❌ Show error dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(redeemResult['error']),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  // ✅ Show success dialog with points
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Success'),
                                      content: Text(
                                        'Points Used: ${points}',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                // 🚫 Show unexpected format dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                      'Unexpected response format.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              // Navigator.of(
                              //   context,
                              // ).pop(); // Close confirmation dialog

                              // // Navigate to success page
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => RedemptionSuccessPage(),
                              //   ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF05024),
                            ),
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    }
                  },
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF05024),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Redeem Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
