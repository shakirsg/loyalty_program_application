import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  late AnimationController _animationController;
  late Animation<double> _animation;

  final double scanBoxSize = 250;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: scanBoxSize).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && controller != null) {
      controller!.pauseCamera();
    } else if (Platform.isIOS && controller != null) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        backgroundColor: Color(0xFFF05024),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Center(
            child: Stack(
              children: [
                // White border
                Container(
                  width: scanBoxSize,
                  height: scanBoxSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                // Red corners
                Positioned(top: 0, left: 0, child: _cornerBox(Alignment.topLeft)),
                Positioned(top: 0, right: 0, child: _cornerBox(Alignment.topRight)),
                Positioned(bottom: 0, left: 0, child: _cornerBox(Alignment.bottomLeft)),
                Positioned(bottom: 0, right: 0, child: _cornerBox(Alignment.bottomRight)),

                // Animated red scanline
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: _animation.value,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: scanBoxSize,
                        height: 2,
                        color: Colors.redAccent,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Scan result
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: (result != null)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Barcode Type: ${describeEnum(result!.format)}\nData: ${result!.code}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              result = null;
                            });
                          },
                          child: Text('Scan Again'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                      ],
                    )
                  : Text(
                      'Scan a code',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerBox(Alignment alignment) {
    return Container(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _CornerPainter(color: Colors.red, alignment: alignment),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final Alignment alignment;

  _CornerPainter({required this.color, required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height * 0.3);
      path.lineTo(0, 0);
      path.lineTo(size.width * 0.3, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width * 0.7, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.3);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, size.height * 0.7);
      path.lineTo(0, size.height);
      path.lineTo(size.width * 0.3, size.height);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width * 0.7, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height * 0.7);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
