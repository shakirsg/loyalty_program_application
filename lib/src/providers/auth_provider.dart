import 'package:flutter/material.dart';
import 'package:metsec_loyalty_app/src/services/api_service.dart';
import 'package:metsec_loyalty_app/src/services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isRemember = false;

  bool isLoading = false;
  bool isSigningWithGoogle = false;
  String? error;
  String? token;

  // UserProfile
  bool isLoadingUserProfile = false;
  bool isLoadingOtp = false;

  Map<String, dynamic>? userProfile;
  String? fullName = "";
  String? email;

  bool termsAccepted = false;


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
    required String idNumber,
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
        idNumber: idNumber,
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
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      if (response is Map<String, dynamic> && response.containsKey('key')) {
        token = response['key'];
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
    try {
      final profile = await _apiService.fetchUserProfile(token!);
      userProfile = profile;

      // Full name
      fullName = (userProfile?['full_name'] ?? "");
      // Email
      email = (userProfile?['email'] ?? "");
    } catch (e) {
      error = "Failed to fetch profile: ${e.toString()}";
    } finally {
      isLoadingUserProfile = false;
      notifyListeners();
    }
  }

  Future<String?> loginWithGoogle() async {
    isSigningWithGoogle = true;
    error = null;
    notifyListeners();

    try {
      final res = await _apiService.signInWithGoogle();
      if (res == null) {
        error = 'Failed to sign in with Google';
        return null;
      }
      await LocalStorageService.saveToken(res);
      await LocalStorageService.saveRemember(true);
      token = res;
      debugPrint('Provider Token: $token');

      return res;
    } catch (e) {
      error = "Google login failed: ${e.toString()}";
    } finally {
      await _apiService.signOut();

      isSigningWithGoogle = false;
      notifyListeners();
    }
    return null;
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
