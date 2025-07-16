import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';

class StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoadingUserPoints;

    return Card(
      elevation: 4,
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, size: 24, color: const Color(0xFFF05024)),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? SkeletonLoader(
                          builder: Column(
                            children: [
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // const SizedBox(height: 10),
                              // Container(
                              //   height: 20,
                              //   width: MediaQuery.of(context).size.width * 0.8,
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey[300],
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              // ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
