import 'package:flutter/material.dart';

class RecentActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String date;
  final String location;
  final String downtime;

  const RecentActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.date,
    required this.location,
    required this.downtime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon section on the left
            CircleAvatar(
              backgroundColor: Color(0xFFDCFCE7),
              child: Icon(icon, color: Color(0xFF16A34A)),
            ),
            const SizedBox(width: 12),
            // Main content section on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Value side by side at the top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFF16A34A),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Date and Location at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      // Location with location icon
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // const SizedBox(height: 8),
                  // // Downtime information
                  // Text(
                  //   'Downtime: $downtime',
                  //   style: const TextStyle(fontSize: 14, color: Colors.red),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
