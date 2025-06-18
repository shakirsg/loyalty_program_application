import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/services/local_storage_service.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String? error;
  String? token;

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
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
        await LocalStorageService.saveToken(token!); // Save token
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

}
