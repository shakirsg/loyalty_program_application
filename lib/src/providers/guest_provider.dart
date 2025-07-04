import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/services/api_service.dart';

class GuestProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? productInfo;
  String? errorMessage;
  bool isLoading = false;

  Future<void> authenticateProductByQR(String qrCode) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.authenticateProduct(qrCode: qrCode);
      productInfo = response;
    } catch (e) {
      errorMessage = e.toString();
      productInfo = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
