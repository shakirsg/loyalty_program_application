import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/services/local_storage_service.dart';
import 'package:loyalty_program_application/src/services/location_service.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userData;

  //
  bool isLoading = false;
  String? error;
  String? token;
  //claimPointsWithLocation
  bool isClaiming = false;
  String? errorClaim;
  dynamic claimResult;
  // getUserPoints
  dynamic pointsData;
  double total_points = 0.0;
  List<dynamic> pointHistory = [];

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
      pointsData = await _apiService.getPoints(token!);
      print('Raw API response: $pointsData');
      // total_points
      total_points = (pointsData?['total_points'] ?? 0).toDouble();
      // Historys
      pointHistory = pointsData?['points'] ?? [];
      print("User points: $total_points");
      print("History count: ${pointHistory.length}");
    } catch (e) {
      error = "Failed to fetch points: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Rewards
  List<dynamic> rewards = [];
  String? rewardsError;
  bool isLoadingRewards = false;

  bool isRedeeming = false;
  String? redeemError;
  dynamic redeemResult;

  /// Fetch list of rewards
  Future<void> fetchRewardsList() async {
    isLoadingRewards = true;
    rewardsError = null;
    notifyListeners();

    try {
      token = await LocalStorageService.getToken();

      final response = await _apiService.getRewardsList(token!);
      // rewards = response;
      // Use raw map data from the "results" key
      rewards = List<Map<String, dynamic>>.from(response['results']);
    } catch (e) {
      rewardsError = "Failed to fetch rewards: ${e.toString()}";
    } finally {
      isLoadingRewards = false;
      notifyListeners();
    }
  }

  /// Redeem a reward by ID
  Future<void> redeemRewardById(int rewardId) async {
    isRedeeming = true;
    redeemError = null;
    notifyListeners();

    try {
      token = await LocalStorageService.getToken();

      final response = await _apiService.redeemReward(
        token: token!,
        rewardId: rewardId,
      );

      redeemResult = response;

      // Optionally refresh user points
      // await getUserPoints();
    } catch (e) {
      redeemError = "Failed to redeem reward: ${e.toString()}";
    } finally {
      isRedeeming = false;
      notifyListeners();
    }
  }
}
