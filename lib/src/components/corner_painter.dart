import 'package:flutter/material.dart';

class CornerPainter extends CustomPainter {
  final Color color;
  final Alignment alignment;

  CornerPainter({required this.color, required this.alignment});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final radius = 16.0;      // Matches borderRadius.circular(16)
    final lineLength = 20.0;  // Length of the corner lines

    final path = Path();

    if (alignment == Alignment.topLeft) {
      // Vertical line down
      path.moveTo(0, radius + lineLength);
      path.lineTo(0, radius);
      // Arc from vertical to horizontal line
      path.arcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      // Horizontal line right
      path.lineTo(radius + lineLength, 0);
    } else if (alignment == Alignment.topRight) {
      // Vertical line down
      path.moveTo(size.width, radius + lineLength);
      path.lineTo(size.width, radius);
      // Arc from vertical to horizontal line
      path.arcToPoint(
        Offset(size.width - radius, 0),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      // Horizontal line left
      path.lineTo(size.width - radius - lineLength, 0);
    } else if (alignment == Alignment.bottomLeft) {
      // Vertical line up
      path.moveTo(0, size.height - radius - lineLength);
      path.lineTo(0, size.height - radius);
      // Arc from vertical to horizontal line
      path.arcToPoint(
        Offset(radius, size.height),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      // Horizontal line right
      path.lineTo(radius + lineLength, size.height);
    } else if (alignment == Alignment.bottomRight) {
      // Vertical line up
      path.moveTo(size.width, size.height - radius - lineLength);
      path.lineTo(size.width, size.height - radius);
      // Arc from vertical to horizontal line
      path.arcToPoint(
        Offset(size.width - radius, size.height),
        radius: Radius.circular(radius),
        clockwise: true,
      );
      // Horizontal line left
      path.lineTo(size.width - radius - lineLength, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
