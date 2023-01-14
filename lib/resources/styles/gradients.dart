import 'package:flutter/material.dart';

class Gradients {
  static RadialGradient playListGradient(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return RadialGradient(
        center: Alignment.centerLeft,
        radius: 7,
        colors: [colors.secondary, colors.primary]);
  }

  static LinearGradient bottomBarBg(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colors.tertiary.withAlpha(0), colors.tertiary]);
  }

  static LinearGradient checkPointBg(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.primary, colors.secondary]);
  }
}
