import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class ApiService {
  final String baseUrl =
      'http://68.183.83.230:8000/api'; // from Insomnia environment
  final String token =
      'e8c5dd2880884862a0ec4edb1fa028f0aec35d01'; // from Insomnia environment

  Map<String, String> get _headers => {
    'Authorization': 'Token $token',
    'Content-Type': 'application/json',
    'User-Agent': 'insomnia/11.0.0',
  };

  /// Get user profile
  Future<dynamic> fetchUserProfile(String token) async {
    final url = Uri.parse('$baseUrl/customers/profile');
    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }

  /// Register a new customer
  Future<dynamic> registerCustomer({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/customers/register/');
    final body = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "email": email,
      "password": password,
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

    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };

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
    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get points');
    }
  }

  /// Login user
  Future<dynamic> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/dj-rest-auth/login/');
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'insomnia/11.0.0',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // You'll get token here
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// Get product points
  Future<dynamic> getProductPoints() async {
    final url = Uri.parse('$baseUrl/customers/product-points/');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get product points');
    }
  }

  // Google SignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId:
        '388610220112-no1q7frmmdmimcu0a4608cp5qg1c9ug4.apps.googleusercontent.com', // ⬅️ From Google Cloud Console
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
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

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent':
            'insomnia/11.0.0', // You can change this to something more appropriate if needed
      },
      body: body,
    );

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

  /// Get a list of available rewards
  Future<dynamic> getRewardsList(String token) async {
    final url = Uri.parse('$baseUrl/products/rewards/');
    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };

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
    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };

    final body = jsonEncode({'reward_id': rewardId});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } if (response.statusCode == 404) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to redeem reward: ${response.body}');
    }
  }

  /// Get total points
  Future<dynamic> getRedeemedPoints(String token) async {
    final url = Uri.parse('$baseUrl/customers/reward-redemptions/');
    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get redeemed points');
    }
  }

  /// Get total points
  Future<dynamic> authenticateProduct({
    required String qrCode,
  }) async {
    final url = Uri.parse(
      '$baseUrl/customers/authenticate-product/?qr_code=${Uri.encodeComponent(qrCode)}',
    );

    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'insomnia/11.0.0',
    };


    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate product: ${response.body}');
    }
  }
}
