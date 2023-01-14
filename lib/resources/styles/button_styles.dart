import 'package:flutter/material.dart';
import 'package:music_player/utils/themes_utils.dart';

class ButtonStyles {
  static ButtonStyle flatButtonStyle(double _height, double _width) {
    return TextButton.styleFrom(
      backgroundColor: Colors.grey,
      padding: EdgeInsets.all(0),
    );
  }

  static ButtonStyle circleButtonStyle(size) {
    return TextButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.all(0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(size)));
  }

  static ButtonStyle squareRoundedButtonStyle(double size, Color? color) {
    return IconButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size * 0.1)));
  }

  static ButtonStyle accentTextButton(BuildContext context) {
    return ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary));
  }

  static ButtonStyle secondaryOption(BuildContext context) {
    return ButtonStyle(
        foregroundColor: MaterialStateProperty.all(ThemeUtils.getInvertedColor(context)));
  }
}
