import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/notifications_page.dart';  // Import Notifications Page

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFF05024),
      ),
      backgroundColor: const Color(0xFFEFEFEF),

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
                      'Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Welcome to your profile!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile info panel
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe', // Replace with user name
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'john.doe@example.com',
                            ), // Replace with user email
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to Manage Account page
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Points and Redeem panel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Points: 1200',
                        ), // Replace with user points
                        ElevatedButton(
                          onPressed: () {
                            // Redeem action
                          },
                          child: Text('Redeem'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Wrap the settings items inside a Card
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Column(
                children: [
                  // Notifications Item
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '3',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () {
                      // Navigate to Notifications page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(),  // Navigate here
                        ),
                      );
                    },
                  ),
                  Divider(),
                  // Privacy & Security Item
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Privacy & Security'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to privacy settings
                    },
                  ),
                  Divider(),
                  // Help & Support Item
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help & Support'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to help and support page
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
