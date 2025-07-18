import 'package:flutter/material.dart';
import 'package:metsec_loyalty_app/src/pages/manage_account_page.dart';
import 'package:metsec_loyalty_app/src/providers/auth_provider.dart';
import 'package:metsec_loyalty_app/src/providers/navigation_provider.dart';
import 'package:metsec_loyalty_app/src/providers/user_provider.dart';
import 'package:metsec_loyalty_app/src/services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<AuthProvider>(context).userProfile;
    final fullName = context.watch<AuthProvider>().fullName;
    final email = context.watch<AuthProvider>().email;

    final phone = userProfile?['phone'] ?? 'N/A';
    final profession = userProfile?['profession'] ?? 'N/A';
    final city = userProfile?['city'] ?? 'N/A';
    final county = userProfile?['county'] ?? 'N/A';
    final country = userProfile?['country'] ?? 'N/A';
    final idNumber = userProfile?['id_number'] ?? 'N/A';
    final created = userProfile?['created'] ?? 'N/A';
    final updated = userProfile?['updated'] ?? 'N/A';
    final points = context.watch<UserProvider>().totalPoints.toStringAsFixed(
      3,
    );
    final isLoadingUserProfile = context
        .watch<AuthProvider>()
        .isLoadingUserProfile;
    final isLoadingUserPoints = context
        .watch<UserProvider>()
        .isLoadingUserPoints;

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
            isLoadingUserProfile || isLoadingUserPoints
                ? SkeletonLoader(
                    builder: Card(
                      margin: EdgeInsets.all(16),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 30),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 16,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: 180,
                                      height: 14,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  height: 14,
                                  color: Colors.grey[300],
                                ),
                                Container(
                                  width: 80,
                                  height: 36,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    items: 1,
                    period: Duration(seconds: 2),
                    highlightColor: Colors.grey[100]!,
                    direction: SkeletonDirection.ltr,
                  )
                : Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: AssetImage(
                                  'assets/avatar.png',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName ?? 'User',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      email ?? 'No email',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.deepOrange,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManageAccountPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              _buildInfoTile(Icons.phone, 'Phone', phone),
                              _buildInfoTile(
                                Icons.work,
                                'Profession',
                                profession,
                              ),
                              _buildInfoTile(Icons.location_city, 'City', city),
                              _buildInfoTile(Icons.map, 'County', county),
                              _buildInfoTile(Icons.flag, 'Country', country),
                              _buildInfoTile(
                                Icons.credit_card,
                                'ID Number',
                                idNumber?.isNotEmpty == true ? idNumber : 'N/A',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          // _buildDateRow('Account Created:', created),
                          // _buildDateRow('Last Updated:', updated),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Available Points',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  points,
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            // Card(
            //   margin: EdgeInsets.all(16),
            //   elevation: 5,
            //   child: // ... inside the last Card widget's child Column:
            //   Column(
            //     children: [
            //       // Notifications Item
            //       ListTile(
            //         leading: Icon(Icons.notifications_outlined),
            //         title: Text('Notifications'),
            //         trailing: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             CircleAvatar(
            //               radius: 10,
            //               backgroundColor: Colors.red,
            //               child: Text(
            //                 '3',
            //                 style: TextStyle(fontSize: 12, color: Colors.white),
            //               ),
            //             ),
            //             Icon(Icons.arrow_forward_ios),
            //           ],
            //         ),
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => NotificationsPage(),
            //             ),
            //           );
            //         },
            //       ),
            //       Divider(),
            //       // Privacy & Security Item
            //       ListTile(
            //         leading: Icon(Icons.lock_outline),
            //         title: Text('Privacy & Security'),
            //         trailing: Icon(Icons.arrow_forward_ios),
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => PrivacySecurityPage(),
            //             ),
            //           );
            //         },
            //       ),
            //       Divider(),
            //       // Help & Support Item
            //       ListTile(
            //         leading: Icon(Icons.help_outline),
            //         title: Text('Help & Support'),
            //         trailing: Icon(Icons.arrow_forward_ios),
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => HelpSupportPage(),
            //             ),
            //           );
            //         },
            //       ),
            //       // Divider(),
            //       // After the last Card widget inside the Column's children:
            //     ],
            //   ),
            // ),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(
                          0xFFFFF5F3,
                        ), // Light warm background color
                        title: Text(
                          'Logout',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Clear the token (logout logic)
                              await LocalStorageService.deleteToken();
                              await LocalStorageService.saveRemember(false);

                              // Optional: Clear auth/user state if using Provider
                              // Provider.of<AuthProvider>(context, listen: false).logout(); ← if you have it
                              context.read<NavigationProvider>().setIndex_(0);
                              final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              );
                              userProvider.reset();

                              // Then navigate or clean session
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widgets:
  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text('$label: ${value ?? 'N/A'}', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildDateRow(String label, String? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              date ?? 'N/A',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
