import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isLoadingUserPoints = userProvider.isLoadingUserPoints;
    final points = userProvider.total_points.toStringAsFixed(3);

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday

    final thisWeekPoints = userProvider.pointHistory
        .where((item) {
          final created =
              DateTime.tryParse(item['created'] ?? '') ?? DateTime(2000);
          return created.isAfter(startOfWeek);
        })
        .fold<double>(0.0, (sum, item) => sum + (item['points'] ?? 0.0));

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

                // Skeleton or Actual Points
                if (isLoadingUserPoints)
                  SkeletonLoader(
                    builder: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else ...[
                  // Actual Points
                  Text(
                    '$points pts',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bottom Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12,
                            child: Icon(
                              Icons.trending_up,
                              color: Color(0xFF22C55E),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Got ${thisWeekPoints.toStringAsFixed(0)} pts this week',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF22C55E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 12,
                            child: Icon(
                              Icons.access_time,
                              color: Colors.white,
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
              ],
            ),
          ),

          // Icon at top-right corner
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: const Color.fromRGBO(254, 236, 231, 1.0),
              radius: 16,
              child: const Icon(Icons.flash_on, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
