import 'package:flutter/material.dart';

class ManageAccountPage extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
            // Orange background section with rounded bottom
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
                      'Manage Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Update your profile information',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Main Panel with Profile Picture and Description
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Picture and Description
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        './assets/avatar.png',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'John Doe', // This can be dynamic if needed
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You can update your information below.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Form Card
            Card(
              margin: EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Full Name Input
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Email Address Input
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Phone Number Input
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Save Button at the Bottom (full width)
            // Save Button at the Bottom (full width)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity, // This ensures full width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save action
                    String fullName = fullNameController.text;
                    String email = emailController.text;
                    String phone = phoneController.text;

                    // Here, you can send the data to an API or save it locally

                    // Show a confirmation message or navigate back to the profile page
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Profile Updated'),
                        content: Text(
                          'Your information has been successfully updated!',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(
                                context,
                              ); // Navigate back to the Profile Page
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFFF05024),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
