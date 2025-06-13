import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        backgroundColor: Color(0xFFF05024),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white, // Set your desired color here
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Orange background section
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFFF05024),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Need help? We\'re here for you!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // First card (Chat with us)
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25, // Size of the circle
                    backgroundColor: Color.fromRGBO(
                      254,
                      236,
                      231,
                      1.0,
                    ), // Circle color
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 30, // Icon size inside the circle
                      color: Color(0xFFF05024),
                    ),
                  ),
                  title: Text('Chat with Us'),
                  subtitle: Text('Chat with our customer support team.'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to chat page or open chat feature
                  },
                ),
              ),
            ),
            // Second card (FAQ)
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(254, 236, 231, 1.0),
                    child: Icon(
                      Icons.question_answer_outlined,
                      size: 30,
                      color: Color(0xFFF05024),
                    ),
                  ),
                  title: Text('FAQ'),
                  subtitle: Text('Find answers to common questions.'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to FAQ page or show FAQ
                  },
                ),
              ),
            ),
            // Third card (Email Support)
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(254, 236, 231, 1.0),
                    child: Icon(
                      Icons.email_outlined,
                      size: 30,
                      color: Color(0xFFF05024),
                    ),
                  ),
                  title: Text('Email Support'),
                  subtitle: Text('Reach out to us via email for support.'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to email support page or open email
                  },
                ),
              ),
            ),
            // Fourth card (Call Us)
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(254, 236, 231, 1.0),
                    child: Icon(
                      Icons.phone_outlined,
                      size: 30,
                      color: Color(0xFFF05024),
                    ),
                  ),
                  title: Text('Call Us'),
                  subtitle: Text('Get in touch with us over the phone.'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to call page or dial the support number
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
