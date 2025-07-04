import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/authenticate_page.dart';

class StandingPage extends StatefulWidget {
  const StandingPage({super.key});

  @override
  State<StandingPage> createState() => _StandingPage();
}

class _StandingPage extends State<StandingPage> {
  void _onRegister() {
    Navigator.pushReplacementNamed(context, '/login');

    print('Register button tapped');
  }

  void _onCallSupport() {
    // TODO: Launch phone dialer
    print('Call support tapped');
  }

  void _onScanQRCode() {
    // TODO: Open QR code scanner
    // TODO: Navigate to registration screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AuthenticatePage()),
    );
    print('QR Scan tapped');
  }

  void _onShowInfo() {
    // TODO: Show app info
    print('Info tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo and CTA
            Container(
              color: Color(0xFF0052A2),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/energya_logo.png', // Replace with your logo path
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Join Energya Zawadi Program',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE7522C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Join Now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // QR Illustration (placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Your trusted source\nfor top quality electrical cables',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/qr_illustration.png', // Replace with your illustration
                    height: 160,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Authenticate Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Action Icons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionIcon(Icons.phone, _onCallSupport),
                  _buildScanButton(_onScanQRCode),
                  _buildActionIcon(Icons.info_outline, _onShowInfo),
                ],
              ),
            ),

            // Footer Branding
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'By QARA',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFE7522C),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildScanButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF0052A2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
      ),
    );
  }
}
