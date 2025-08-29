// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:metsec_loyalty_app/src/pages/history_page.dart';
import 'package:metsec_loyalty_app/src/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:geolocator/geolocator.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  QRViewExampleState createState() => QRViewExampleState();
}

class QRViewExampleState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  late AnimationController _animationController;

  final double scanBoxSize = 250;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    // ignore: deprecated_member_use
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Widget _buildHistoryButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.work_history, color: Colors.white),
      tooltip: 'History',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HistoryPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text('Scan QR Code to Redeem Points'),
        actions: [_buildHistoryButton(context)],
      ),
      body: Stack(
        children: [
          // Camera view
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            cameraFacing: CameraFacing.back,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 20,
              borderWidth: 5,
              cutOutSize: scanBoxSize,
            ),
          ),
          // Animated overlay
          Center(
            child: Stack(
              children: [
                Container(
                  width: scanBoxSize,
                  height: scanBoxSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // ... your corner boxes & animated red line
              ],
            ),
          ),
          if (result != null) _buildResultOverlay(),
        ],
      ),
    );
  }

  Widget _buildResultOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top section with scan result
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Scan Complete',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Barcode Type: ${result!.format.name}\nData: ${result!.code}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await controller?.resumeCamera();
                    if (!mounted) return;
                    setState(() {
                      result = null;
                      isProcessing = false;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _handleClaimPoints(context, '${result!.code}');
                  },
                  icon: const Icon(Icons.trending_up),
                  label: const Text('Get Points'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isProcessing && result == null) {
        isProcessing = true;
        setState(() {
          result = scanData;
        });
        try {
          await controller.pauseCamera();
        } catch (e) {
          debugPrint('Camera error: $e');
        }
      }
    });
  }

  /// Handles the flow for claiming points with location permission
  Future<void> _handleClaimPoints(BuildContext context, String qrCode) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // Already granted → claim points directly
      await _claim(context, qrCode);
      return;
    }

    if (permission == LocationPermission.denied) {
      // Show disclosure before requesting
      final consent = await _showLocationDisclosure(context);
      if (!consent) return;

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await _claim(context, qrCode);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permission permanently denied. Please enable it in Settings.",
          ),
        ),
      );
    }
  }

  /// Calls provider and handles loading + dialogs
  Future<void> _claim(BuildContext context, String qrCode) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Provider.of<UserProvider>(
      context,
      listen: false,
    ).claimPointsWithLocation(qrCode);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // close loading
    }

    final claimResult = Provider.of<UserProvider>(
      context,
      listen: false,
    ).claimResult;

    if (claimResult is Map<String, dynamic>) {
      if (claimResult.containsKey('detail')) {
        _showResultDialog(
          context,
          "Unable to claim points, ${claimResult['detail']}",
          Icons.error,
          Colors.red,
        );
      } else {
        _showResultDialog(
          context,
          "You have earned ${claimResult['points']} points",
          Icons.celebration,
          Colors.green,
        );
      }
    } else {
      _showResultDialog(
        context,
        "Unexpected response format.",
        Icons.error,
        Colors.red,
      );
    }

    Provider.of<UserProvider>(context, listen: false).getUserPoints();
  }

  void _showResultDialog(
    BuildContext context,
    String message,
    IconData icon,
    Color iconColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Prominent disclosure dialog
  Future<bool> _showLocationDisclosure(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Location Permission Required"),
              content: const Text(
                "This app collects location data to verify your presence when claiming points. "
                "Your location is only used for this feature and is never shared with third parties.",
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Allow"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                TextButton(
                  child: const Text("No Thanks", style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
