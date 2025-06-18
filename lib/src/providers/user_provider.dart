import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/services/local_storage_service.dart';
import 'package:loyalty_program_application/src/services/location_service.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userData;

  int points = 0;

  bool isLoading = false;
  String? error;
  String? token;
  //claimPointsWithLocation
  bool isClaiming = false;
  String? errorClaim;
  dynamic claimResult;

  Future<void> claimPointsWithLocation(String qrCode) async {
    isClaiming = true;
    error = null;
    notifyListeners();

    try {
      final position = await LocationService.determinePosition();
      final address = await LocationService.getAddressFromPosition(position);
      token = await LocalStorageService.getToken();

      final result = await _apiService.claimPoints(
        token: token!,
        qrCode: qrCode,
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      claimResult = result;

      // Optionally update user points again here
      await getUserPoints();
    } catch (e) {
      error = e.toString();
    } finally {
      isClaiming = false;
      notifyListeners();
    }
  }

  /// Fetch user points
  Future<void> getUserPoints() async {
    isLoading = true;
    error = null;
    notifyListeners();

    token = await LocalStorageService.getToken();
    print("getUserPoints...");

    try {
      final pointsData = await _apiService.getPoints(token!);
      points = pointsData['points'] ?? 0;
      print("User points: $points");
    } catch (e) {
      error = "Failed to fetch points: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
