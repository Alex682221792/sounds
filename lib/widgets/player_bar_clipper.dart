import 'package:flutter/material.dart';
import 'package:music_player/resources/values/dimens.dart';

class PlayerBarClipper extends CustomClipper<Path> {
  double cornerRadius;

  PlayerBarClipper(this.cornerRadius);

  @override
  getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - cornerRadius);
    path.quadraticBezierTo(0.0, size.height, cornerRadius, size.height);
    path.lineTo(size.width - cornerRadius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - cornerRadius);
    path.lineTo(size.width, cornerRadius);
    path.quadraticBezierTo(size.width, 0.0, size.width - cornerRadius, 0.0);

    path.lineTo((Dimens.mainButtonSize * 0.625) + Dimens.normalPadding, 0.0);
    path.quadraticBezierTo(
        (Dimens.mainButtonSize * 0.625) + Dimens.normalPadding,
        (Dimens.mainButtonSize * 0.625) + Dimens.normalPadding,
        0.0,
        (Dimens.mainButtonSize * 0.625) + Dimens.normalPadding);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
