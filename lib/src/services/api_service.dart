import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:metsec_loyalty_app/src/services/local_storage_service.dart';

class ApiService {
  final String baseUrl = 'https://dev.eyby.com/api';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  Future<String?> getToken() async => await LocalStorageService.getToken();

  /// Get user profile
  Future<dynamic> fetchUserProfile(String token) async {
    final url = Uri.parse('$baseUrl/customers/profile');
    final headers = {..._headers, 'Authorization': 'Token $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }

  /// Update UserProfiles
  Future<dynamic> updateUserProfile({
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
    final url = Uri.parse('$baseUrl/customers/profile/');
    final body = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "password": password,
      "city": city,
      "county": county,
      "country": country,
      "profession": profession,
      "id_number": idNumber,
    });

    final token = await getToken();

    final response = await http.patch(
      url,
      headers: {..._headers, 'Authorization': 'Token $token'},
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update Profile: ${response.body}');
    }
  }

  /// Register a new customer
  Future<dynamic> registerCustomer({
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
    final url = Uri.parse('$baseUrl/customers/register/');
    final body = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "password": password,
      "city": city,
      "county": county,
      "country": country,
      "profession": profession,
      "id_number": idNumber,
    });

    final response = await http.post(url, headers: _headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  /// Claim points with a QR code
  /// Claim points with a QR code and location info
  Future<dynamic> claimPoints({
    required String token,
    required String qrCode,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final url = Uri.parse(
      '$baseUrl/customers/claim-points/?qr_code=${Uri.encodeComponent(qrCode)}',
    );

    final headers = {..._headers, 'Authorization': 'Token $token'};

    final body = jsonEncode({
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to claim points: ${response.body}');
    }
  }

  /// Get total points
  Future<dynamic> getPoints(String token) async {
    final url = Uri.parse('$baseUrl/customers/points');
    final headers = {..._headers, 'Authorization': 'Token $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get points');
    }
  }

  /// Login user
  Future<dynamic> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/dj-rest-auth/login/');
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: _headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // You'll get token here
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// Get product points
  Future<dynamic> getProductPoints() async {
    final token = await getToken();

    final url = Uri.parse('$baseUrl/customers/product-points/');
    final response = await http.get(
      url,
      headers: {..._headers, 'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get product points');
    }
  }

  // Google SignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      if (accessToken == null) throw Exception("Access token is null");

      final response = await http.post(
        Uri.parse("$baseUrl/users/social/google/"),
        headers: _headers,
        body: jsonEncode({"access_token": accessToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['key'] ?? data['access'];

        return token;
      } else {
        debugPrint("Login failed:");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    return null;
  }

  Future<dynamic> loginWithGoogle(
    String email,
    String firstName,
    String lastName,
    String googleId,
    String photoUrl,
    String loginMethod,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/dj-rest-auth/login/');

    // Prepare the request body with the new data format
    final body = jsonEncode({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'google_id': googleId,
      'photo_url': photoUrl,
      'login_method': loginMethod,
      'password': password,
    });

    final response = await http.post(url, headers: _headers, body: body);

    // Check the response status
    if (response.statusCode == 200) {
      return jsonDecode(response.body); // The response will contain the token
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Get a list of available rewards with search and category filters
  Future<dynamic> getRewardsList(
    String token,
    String search,
    String categoryName,
  ) async {
    final url = Uri.parse(
      '$baseUrl/products/rewards/?search=$search&category__name=$categoryName',
    );

    final headers = {..._headers, 'Authorization': 'Token $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch rewards list: ${response.body}');
    }
  }

  /// Redeem a reward by reward ID
  Future<dynamic> redeemReward({
    required String token,
    required int rewardId,
  }) async {
    final url = Uri.parse('$baseUrl/customers/redeem-reward/');
    final headers = {..._headers, 'Authorization': 'Token $token'};

    final body = jsonEncode({'reward_id': rewardId});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 404) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to redeem reward: ${response.body}');
    }
  }

  /// Get total points
  Future<dynamic> getRedeemedPoints(String token) async {
    final url = Uri.parse('$baseUrl/customers/reward-redemptions/');
    final headers = {..._headers, 'Authorization': 'Token $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get redeemed points');
    }
  }

  /// Get total points
  Future<dynamic> authenticateProduct({required String qrCode}) async {
    final url = Uri.parse(
      '$baseUrl/customers/authenticate-product/?qr_code=${Uri.encodeComponent(qrCode)}',
    );

    final response = await http.get(url, headers: _headers);

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate product: ${response.body}');
    }
  }

  /// send Otp
  Future<dynamic> getOtp({required String phoneNumber}) async {
    final url = Uri.parse(
      '$baseUrl/customers/otp/get_otp/?phone=${Uri.encodeComponent(phoneNumber)}',
    );

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 406) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate product: ${response.body}');
    }
  }

  /// send Otp
  Future<dynamic> verifyOtp({required String otp}) async {
    final url = Uri.parse(
      '$baseUrl/customers/otp/verify_otp/?otp=${Uri.encodeComponent(otp)}',
    );

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate product: ${response.body}');
    }
  }

  Future<dynamic> getCategories() async {
    final url = Uri.parse('$baseUrl/products/reward-categories/');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch Categories: ${response.body}');
    }
  }
}
