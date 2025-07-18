import 'package:flutter/material.dart';
import 'package:metsec_loyalty_app/src/services/local_storage_service.dart';
import 'package:metsec_loyalty_app/src/services/location_service.dart';
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
  bool isLoadingUserPoints = false;

  dynamic pointsData;
  double totalPoints = 0.0;
  List<dynamic> pointHistory = [];

  Future<void> claimPointsWithLocation(String qrCode) async {
    isClaiming = true;
    error = null;
    notifyListeners();

    try {
      final position = await LocationService.determinePosition();
      // final address = await LocationService.getAddressFromPosition(position);
      token = await LocalStorageService.getToken();

      final result = await _apiService.claimPoints(
        token: token!,
        qrCode: qrCode,
        latitude: position.latitude,
        longitude: position.longitude,
        // latitude: 0.0,
        // longitude: 0.0,
        address: "address",
      );

      claimResult = result;
      // Optionally update user points again here
      // await getUserPoints();
    } catch (e) {
      error = e.toString();
    } finally {
      isClaiming = false;
      notifyListeners();
    }
  }

  /// Fetch user points
  Future<void> getUserPoints() async {
    isLoadingUserPoints = true;
    error = null;
    notifyListeners();

    token = await LocalStorageService.getToken();

    try {
      pointsData = await _apiService.getPoints(token!);
      // totalPoints
      totalPoints = (pointsData?['total_points'] ?? 0).toDouble();
      // Historys
      pointHistory = pointsData?['points'] ?? [];
    } catch (e) {
      error = "Failed to fetch points: ${e.toString()}";
    } finally {
      isLoadingUserPoints = false;
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

  String searchValue = "";
  String categoryName = "";

  /// Fetch list of rewards
  Future<void> fetchRewardsList() async {
    isLoadingRewards = true;
    rewardsError = null;
    notifyListeners();

    try {
      token = await LocalStorageService.getToken();

      final response = await _apiService.getRewardsList(
        token!,
        searchValue,
        categoryName,
      );
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

  // Get redeemedPoints
  double redeemedPoints = 0.0;
  List<dynamic> redeemedHistory = [];
  String? redeemedPointsError;
  bool isLoadingRedeemedPoints = false;

  Future<void> getRedeemedPoints() async {
    isLoadingRedeemedPoints = true;
    redeemedPointsError = null;
    notifyListeners();

    try {
      token = await LocalStorageService.getToken();
      final response = await _apiService.getRedeemedPoints(token!);

      redeemedPoints = (response['total_points'] ?? 0).toDouble();
      redeemedHistory = response['redemptions'] ?? [];

    } catch (e) {
      redeemedPointsError = "Failed to fetch redeemed points: ${e.toString()}";
    } finally {
      isLoadingRedeemedPoints = false;
      notifyListeners();
    }
  }

  // categories
  List<dynamic> categories = [];
  String? categoriesError;
  bool isLoadingCategories = false;

  /// Fetch list of rewards
  Future<void> fetchCategoryList() async {
    isLoadingCategories = true;
    categoriesError = null;
    notifyListeners();

    try {
      final response = await _apiService.getCategories();
      // rewards = response;
      // Use raw map data from the "results" key
      categories = List<Map<String, dynamic>>.from(response['results']);
    } catch (e) {
      categoriesError = "Failed to fetch rewards: ${e.toString()}";
    } finally {
      isLoadingCategories = false;
      notifyListeners();
    }
  }

  bool isEditing = false;
  String? errorEditing;
  Future<bool> editUserProfile({
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
    isEditing = true;
    errorEditing = null;
    notifyListeners();

    try {
      final response = await _apiService.updateUserProfile(
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

      // // Check if the response is an error or success
      // if (response is Map<String, dynamic> && response.containsKey('id')) {
      //   // Registration successful
      //   return true;
      // } else if (response is String && response.contains("duplicate key")) {
      //   errorEditing = "Email already exists. Please try a different one.";
      // } else {
      //   errorEditing = "Registration failed. Please try again.";
      // }

      return false;
    } catch (e) {
      errorEditing = "Something went wrong: ${e.toString()}";
      return false;
    } finally {
      isEditing = false;
      notifyListeners();
    }
  }

  // Reset everything
  void reset() {
    userData = null;

    isLoading = false;
    error = null;
    token = null;

    isClaiming = false;
    errorClaim = null;
    claimResult = null;

    isLoadingUserPoints = false;
    pointsData = null;
    totalPoints = 0.0;
    pointHistory = [];

    rewards = [];
    rewardsError = null;
    isLoadingRewards = false;

    isRedeeming = false;
    redeemError = null;
    redeemResult = null;

    redeemedPoints = 0.0;
    redeemedHistory = [];
    redeemedPointsError = null;
    isLoadingRedeemedPoints = false;

    categories = [];
    categoriesError = null;
    isLoadingCategories = false;

    searchValue = "";
    categoryName = "";

    notifyListeners();
  }
}
