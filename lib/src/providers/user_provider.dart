import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<void> loadUserProfile(String token) async {
    // _userData = await _apiService.fetchUserProfile();
    print('User profile loaded: $_userData'); // <--- print here

    notifyListeners();
  }
}
