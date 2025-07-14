import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/utils/show_loading_dialog_while.dart';
import 'package:provider/provider.dart';
import './forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _rememberMe = false;
  late TabController _tabController;
  int _selectedLoginMethod = 0; // 0 = Email, 1 = Phone

  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _loginWithEmail() async {
    if (_emailFormKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.login(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      _handleLoginResult(result);
    }
  }

  void _loginWithOtp() async {
    if (_phoneFormKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.loginWithPhoneOtp(
        _phoneController.text.trim(),
        _otpController.text.trim(),
      );
      // Close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      _handleLoginResult(result);
    }
  }

  bool _isOtpSent = false;

  void _getOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length >= 8) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await showLoadingDialogWhile(
        context: context,
        action: () async {
          await authProvider.getOtp(phone);
        },
      );
      final getOtpResponse = authProvider.getOtpResponse;
      if (getOtpResponse?.containsKey("data") == true) {
        setState(() {
          _isOtpSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(getOtpResponse!["data"] ?? "No message"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (getOtpResponse!.containsKey("detail")) {
        setState(() {
          _isOtpSent = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Text(getOtpResponse!["detail"] ?? "No message"),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleLoginResult(dynamic result) {
    if (result is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Login successful!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (Route<dynamic> route) => false, // removes all previous routes
      );
    } else if (result is Map && result.containsKey('non_field_errors')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(result['non_field_errors'][0])),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text('Login failed. Please try again.'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
    );
  }

  void _goToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  void _signInWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Your main content
          Column(
            children: [
              const SizedBox(height: 120),
              const Text(
                'Welcome to Eyby Points!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLoginMethod = 0;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedLoginMethod == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Email Login",
                              style: TextStyle(
                                color: _selectedLoginMethod == 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLoginMethod = 1;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedLoginMethod == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Phone Login",
                              style: TextStyle(
                                color: _selectedLoginMethod == 1
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _selectedLoginMethod == 0
                    ? _buildEmailLoginTab()
                    : _buildPhoneLoginTab(),
              ),
            ],
          ),

          Positioned(
            top: 0,
            right: -30,
            child: GestureDetector(
              onTap: () {
                // Do something when logo is tapped
                // Example: Navigate to settings page
                Navigator.pushNamed(context, '/landing');
              },
              child: Image.asset('assets/eyby.png', width: 200, height: 150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailLoginTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _emailFormKey,
        child: ListView(
          children: [
            // const SizedBox(height: 40),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter your email';
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleVisibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter your password';
                if (value.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    context.read<AuthProvider>().isRemember = value ?? false;

                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text("Remember Me"),
                const Spacer(),
                TextButton(
                  onPressed: _forgotPassword,
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithEmail,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign in'),
                  Icon(Icons.arrow_forward, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.account_circle),
              label: const Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 18.0),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: _goToRegister,
                  child: const Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLoginTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _phoneFormKey,
        child: ListView(
          children: [
            // const SizedBox(height: 40),
            if (!_isOtpSent) ...[
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter phone number'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _getOtp, child: const Text("Get OTP")),
            ] else ...[
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter OTP' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginWithOtp,
                child: const Text("Login with OTP"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isOtpSent = false;
                    _otpController.clear();
                  });
                },
                child: const Text("Edit phone number"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
