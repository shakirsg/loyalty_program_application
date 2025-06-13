import 'package:flutter/material.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Your Points Balance',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Content (points balance)
                const Text(
                  '500 pts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // Bottom left and bottom right details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: "You used 50pts this week" with icon
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor:
                              Colors.white, // Icon background color
                          radius: 12, // Circle size
                          child: Icon(
                            Icons.trending_up,
                            color: Color(0xFF22C55E), // Icon color
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Got 50pts this week',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF22C55E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Right side: "Expires in 3d" with icon
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.red, // Icon background color
                          radius: 12, // Circle size
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white, // Icon color
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '100pts in 3d',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Icon at the top-right corner
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Color.fromRGBO(
                254,
                236,
                231,
                1.0,
              ), // Icon background color
              radius: 16, // Circle size
              child: const Icon(
                Icons.flash_on,
                color: Colors.black, // Icon color
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
