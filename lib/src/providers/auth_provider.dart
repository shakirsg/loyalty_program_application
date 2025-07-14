import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loyalty_program_application/src/services/local_storage_service.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isRemember = false;

  bool isLoading = false;
  String? error;
  String? token;

  // UserProfile
  bool isLoadingUserProfile = false;
  bool isLoadingOtp = false;

  Map<String, dynamic>? userProfile;
  String? fullName = "";
  String? email;

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String city,
    required String county,
    required String country,
    required String profession,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _apiService.registerCustomer(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        city: city,
        county: county,
        country: country,
        profession: profession,
      );

      // Check if the response is an error or success
      if (response is Map<String, dynamic> && response.containsKey('id')) {
        // Registration successful
        return true;
      } else if (response is String && response.contains("duplicate key")) {
        error = "Email already exists. Please try a different one.";
      } else {
        error = "Registration failed. Please try again.";
      }

      return false;
    } catch (e) {
      error = "Something went wrong: ${e.toString()}";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Login method
  Future<dynamic> login({
    required String username,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);

      if (response is Map<String, dynamic> && response.containsKey('key')) {
        token = response['key'];
        print("Login Token: ${token}");
        await LocalStorageService.saveToken(token!);

        if (isRemember) {
          await LocalStorageService.saveRemember(true);
        } else {
          await LocalStorageService.saveRemember(false);
        }

        return token!; // Return token as a string
      } else {
        return response; // This will be the error JSON
      }
    } catch (e) {
      error = "Login failed: ${e.toString()}";
      return {'error': error};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserProfile() async {
    isLoadingUserProfile = true;
    error = null;
    notifyListeners();
    token = await LocalStorageService.getToken();
    print("getUserProfile...");
    try {
      final profile = await _apiService.fetchUserProfile(token!);
      userProfile = profile;

      // Full name
      fullName = (userProfile?['full_name'] ?? "");
      print(fullName);
      // Email
      email = (userProfile?['email'] ?? "");
    } catch (e) {
      error = "Failed to fetch profile: ${e.toString()}";
    } finally {
      isLoadingUserProfile = false;
      notifyListeners();
    }
  }

  // Google Sign In
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<void> signIn() async {
    _user = await _apiService.signInWithGoogle();
    if (_user != null) {
      print('Name: ${_user!.displayName}');
      print('Email: ${_user!.email}');
      print('ID: ${_user!.id}');
      print('Photo URL: ${_user!.photoUrl}');
    } else {
      print('Google Sign-In failed or was cancelled.');
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _apiService.signOut();
    _user = null;
    notifyListeners();
  }
  // loginWithGoogle

  Future<void> loginWithGoogle() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final account = await _apiService.signInWithGoogle();
      if (account == null) {
        error = 'Google sign-in was cancelled.';
        return;
      }

      _user = account;

      final response = await _apiService.loginWithGoogle(
        account.email,
        account.displayName?.split(' ').first ?? '',
        account.displayName?.split(' ').skip(1).join(' ') ?? '',
        account.id,
        account.photoUrl ?? '',
        'google',
        account.id,
      );

      if (response != null && response.containsKey('key')) {
        token = response['key'];
        await LocalStorageService.saveToken(token!);

        if (isRemember) {
          await LocalStorageService.saveRemember(true);
        } else {
          await LocalStorageService.saveRemember(false);
        }
      } else {
        error = "Google login failed: Unexpected response";
      }
    } catch (e) {
      error = "Google login failed: ${e.toString()}";
    } finally {
      await _apiService.signOut();

      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getOtpResponse;

  /// Request OTP
  Future<void> getOtp(String phoneNumber) async {
    try {
      isLoadingOtp = true;
      notifyListeners();

      getOtpResponse = await _apiService.getOtp(phoneNumber: phoneNumber);
      // You can handle response if needed (usually 200 is success)
      // return response;
    } catch (e) {
      rethrow;
    } finally {
      isLoadingOtp = false;
      notifyListeners();
    }
  }

  /// Verify OTP and login
  Future<dynamic> loginWithPhoneOtp(String phone, String otp) async {
    try {
      isLoadingOtp = true;
      notifyListeners();

      final result = await _apiService.verifyOtp(otp: otp);

      // Check if token is returned
      if (result is Map && result.containsKey('key')) {
        token = result['key'];
        await LocalStorageService.saveToken(token!);

        if (isRemember) {
          await LocalStorageService.saveRemember(true);
        } else {
          await LocalStorageService.saveRemember(false);
        }

        print(token);
        return token;
      } else {
        return result;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoadingOtp = false;
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    isRemember = await LocalStorageService.getRemember();
    if (isRemember) {
      token = await LocalStorageService.getToken();
    } else {
      await LocalStorageService.deleteToken();
    }
    notifyListeners();
  }
}
