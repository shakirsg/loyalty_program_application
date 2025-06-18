import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://68.183.83.230:8000/api'; // from Insomnia environment
  final String token = 'e8c5dd2880884862a0ec4edb1fa028f0aec35d01'; // from Insomnia environment

  Map<String, String> get _headers => {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
        'User-Agent': 'insomnia/11.0.0',
      };

  /// Get user profile
  Future<dynamic> fetchUserProfile() async {
    final url = Uri.parse('$baseUrl/customers/profile');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
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
  Future<dynamic> claimPoints(String qrCode) async {
    final url = Uri.parse(
        '$baseUrl/customers/claim-points/?qr_code=$qrCode');

    final response = await http.post(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to claim points');
    }
  }

  /// Get total points
  Future<dynamic> getPoints() async {
    final url = Uri.parse('$baseUrl/customers/points/');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get points');
    }
  }

  /// Login user
  Future<dynamic> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/dj-rest-auth/login/');
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'insomnia/11.0.0',
        },
        body: body);

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
}
