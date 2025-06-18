import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/help_support_page.dart';
import 'package:loyalty_program_application/src/pages/manage_account_page.dart';
import 'package:loyalty_program_application/src/pages/notifications_page.dart';
import 'package:loyalty_program_application/src/pages/privacy_security_page.dart';
import 'package:loyalty_program_application/src/services/local_storage_service.dart'; // Import Notifications Page

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null, // no back button on root page
        title: Text('Profile'),
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
                          backgroundImage: AssetImage('./assets/avatar.png'),
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
                        // IconButton(
                        //   icon: Icon(Icons.edit_outlined), // Outlined edit icon
                        //   onPressed: () {
                        //     // Navigate to Manage Account page
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ManageAccountPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
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
              child: // ... inside the last Card widget's child Column:
              Column(
                children: [
                  // Notifications Item
                  ListTile(
                    leading: Icon(Icons.notifications_outlined),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  // Privacy & Security Item
                  ListTile(
                    leading: Icon(Icons.lock_outline),
                    title: Text('Privacy & Security'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacySecurityPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  // Help & Support Item
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('Help & Support'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  // Divider(),
                  // After the last Card widget inside the Column's children:
                ],
              ),
            ),
            SizedBox(height: 16), // spacing before the button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // red background for logout
                  minimumSize: Size(
                    double.infinity,
                    48,
                  ), // full width, 48 height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.logout),
                label: Text('Log Out'),
                onPressed: () async {
                  // Clear the token (logout logic)
                  await LocalStorageService.deleteToken();

                  // Optional: Clear auth/user state if using Provider
                  // Provider.of<AuthProvider>(context, listen: false).logout(); ← if you have it
                  // TODO: Add your logout logic here
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
