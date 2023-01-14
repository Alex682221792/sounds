import 'package:flutter/material.dart';

class DonutPainter  extends CustomPainter {

  double radius;
  double width;
  Offset offset;

  DonutPainter(this.radius, this.width, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          // ..addOval(Rect.fromCircle(center: Offset(width + radius * 2, width + radius * 2), radius: radius)),
          ..addOval(Rect.fromCircle(center: offset, radius: radius + width)),
        Path()
          ..addOval(Rect.fromCircle(center: offset, radius: radius))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}