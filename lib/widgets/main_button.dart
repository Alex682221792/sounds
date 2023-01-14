import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/resources/styles/gradients.dart';

class MainButton extends StatelessWidget {
  double size;
  String icon;
  Function() callback;

  MainButton(this.callback, {required this.size, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(width: size, height: size),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: Gradients.playListGradient(context))))),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  width: size - 3,
                  height: size - 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  )))),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: MaterialButton(
                height: size * 0.9,
                child: SvgPicture.asset(icon,
                    color: getColorIcon(context),
                    height: size * 0.5),
                onPressed: callback,
                shape: const CircleBorder(),
              )))
    ]);
  }
}

Color getColorIcon(BuildContext context) {
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  if (isDarkMode){
    return Colors.white;
  } else {
    return Theme.of(context).colorScheme.primary;
  }
}
