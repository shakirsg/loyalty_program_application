import 'package:flutter/material.dart';

class FullTabPillIndicator extends Decoration {
  final Color color;
  final double radius;

  const FullTabPillIndicator({
    required this.color,
    this.radius = 30,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FullTabPillPainter(this, color, radius);
  }
}

class _FullTabPillPainter extends BoxPainter {
  final FullTabPillIndicator decoration;
  final Color color;
  final double radius;

  _FullTabPillPainter(this.decoration, this.color, this.radius);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size!;

    final Rect rect = offset & size;

    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, paint);
  }
}
