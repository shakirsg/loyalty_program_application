import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import './forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.login(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result is String) {
        print(result);
        // Login successful (token received)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login successful!')));
        Navigator.pushReplacementNamed(context, '/main');
      } else if (result is Map && result.containsKey('non_field_errors')) {
        // Show error message from backend
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['non_field_errors'][0])));
      } else {
        // Fallback error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  void _goToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  void _signInWithGoogle() async {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // await authProvider.signIn();
    // Implement Google sign-in logic
    print("Google sign-in clicked!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Welcome to Eyby Points!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
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
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _login,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Sign in'),
                                Icon(Icons.arrow_forward, size: 24),
                              ],
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // const SizedBox(height: 40),
              // const Text(
              //   "Or continue with Google",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 16),
              // ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.account_circle),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Customize button color
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
