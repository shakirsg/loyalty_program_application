import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _cityController = TextEditingController();
  final _countyController = TextEditingController();
  final _countryController = TextEditingController();
  final _professionController = TextEditingController();
  final _idNumberController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmVisibility() {
    setState(() => _obscureConfirm = !_obscureConfirm);
  }

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to ensure context is fully loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProfile = authProvider.userProfile ?? {};
      final fullName = authProvider.fullName ?? '';
      final nameParts = fullName.split(' ');

      setState(() {
        _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
        _lastNameController.text = nameParts.length > 1
            ? nameParts.sublist(1).join(' ')
            : '';

        _emailController.text = userProfile['email'] ?? '';
        _phoneController.text = userProfile['phone'] ?? '';
        _professionController.text = userProfile['profession'] ?? '';
        _cityController.text = userProfile['city'] ?? '';
        _countyController.text = userProfile['county'] ?? '';
        _countryController.text = userProfile['country'] ?? '';
        _idNumberController.text = userProfile['id_number'] ?? '';
      });
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _cityController.dispose();
    _countyController.dispose();
    _countryController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfile = authProvider.userProfile ?? {};
    final fullName = authProvider.fullName ?? '';
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
                      backgroundImage: AssetImage('./assets/avatar.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      fullName, // This can be dynamic if needed
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
              margin: const EdgeInsets.all(16),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // First Name
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Country
                    TextField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // City
                    TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // County
                    TextField(
                      controller: _countyController,
                      decoration: const InputDecoration(
                        labelText: 'County',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Profession
                    TextField(
                      controller: _professionController,
                      decoration: const InputDecoration(
                        labelText: 'Profession',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ID Number / Passport Number
                    TextField(
                      controller: _idNumberController,
                      decoration: const InputDecoration(
                        labelText: 'ID Number / Passport Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Phone Number
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextField(
                      controller: _confirmController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _toggleConfirmVisibility,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), // Save Button at the Bottom (full width)
            // Save Button at the Bottom (full width)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity, // This ensures full width
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(
                            0xFFFFF5F3,
                          ), // Light warm background color
                          title: Text(
                            'Save Profile',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text('Are you sure you want to update?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Show loading dialog
                                
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                final userProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );

                                final success = await userProvider
                                    .editUserProfile(
                                      firstName: _firstNameController.text
                                          .trim(),
                                      lastName: _lastNameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      city: _cityController.text.trim(),
                                      county: _countyController.text.trim(),
                                      country: _countryController.text.trim(),
                                      profession: _professionController.text
                                          .trim(),
                                      idNumber: _idNumberController.text.trim(),
                                    );
                                await Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                ).getUserProfile();
                                // Here, you can send the data to an API or  save it locally
                                // Close the loading dialog
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF05024),
                              ),
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFFF05024),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Save Changes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
