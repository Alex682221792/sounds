import 'package:flutter/material.dart';
import 'package:music_player/resources/values/dimens.dart';

class BottomBarClipper extends CustomClipper<Path> {
  double cornerRadius;

  BottomBarClipper(this.cornerRadius);

  @override
  getClip(Size size) {
    final double heightCurve = 0.7;
    final Path path = Path();
    path.lineTo(0.0, size.height - cornerRadius);
    path.quadraticBezierTo(0.0, size.height, cornerRadius, size.height);
    path.lineTo(size.width - cornerRadius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - cornerRadius);
    path.lineTo(size.width, cornerRadius);
    path.quadraticBezierTo(size.width, 0.0, size.width - cornerRadius, 0.0);

    path.lineTo((size.width * 0.6) + (Dimens.mainButtonSize * 1.5), 0.0);
    path.cubicTo(
        (size.width * 0.5) + (Dimens.mainButtonSize * 1.5) - cornerRadius,
        size.height * 0.0,
        (size.width * 0.5) + (Dimens.mainButtonSize * 1.5) - cornerRadius,
        size.height * heightCurve,
        size.width * 0.5,
        size.height * heightCurve);

    path.cubicTo(
        (size.width * 0.5) - (Dimens.mainButtonSize * 1.5) + cornerRadius,
        size.height * heightCurve,
        (size.width * 0.5) - (Dimens.mainButtonSize * 1.5) + cornerRadius,
        size.height * 0.0,
        (size.width * 0.4) - (Dimens.mainButtonSize * 1.5),
        size.height * 0.0
    );

    path.lineTo(cornerRadius, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, cornerRadius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
