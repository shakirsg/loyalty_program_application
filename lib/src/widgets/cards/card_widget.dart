import 'package:flutter/material.dart';
import 'package:metsec_loyalty_app/src/pages/authenticate_page.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String title; // Title as a parameter
  final String description; // Description as a parameter

  const CardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(
      context,
    ).size.width; // Get the width of the screen

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(color: Colors.white),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            Flexible(
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                height: width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 60),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AuthenticatePage()),
                );
              },
              borderRadius: BorderRadius.circular(40),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF0052A2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Authenticate Product",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0052A2),
              ),
            ),
            // // Action Button
            // ElevatedButton(
            //   onPressed: () {
            //     // Action for button press
            //     print("Button pressed for $imageUrl");
            //   },
            //   child: const Text('Learn More'),
            // ),
          ],
        ),
      ),
    );
  }
}
