import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
   

    return Card(
      elevation: 4,
      child: SizedBox(
        height: 120, // Adjust height to give enough space for the description
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // Icon and Title at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, size: 24, color: Color(0xFFF05024)), // Icon
                  const SizedBox(width: 8), // Space between icon and title
                  Text(title, style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(
                height: 12,
              ), // Space between the top section and description
              // Main panel with the description
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
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
