import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;

  const CardWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // Get the width of the screen

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        borderRadius: BorderRadius.zero, 
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            // Card Image (same as screen width)
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: width, // Set height to the screen width
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            // Card Title
            const Text(
              'Sample Card Title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Card Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'This is a sample description for the card. You can add more information here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            // Action Button
            ElevatedButton(
              onPressed: () {
                // Action for button press
                print("Button pressed for $imageUrl");
              },
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }
}
