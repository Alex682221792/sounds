import 'package:flutter/material.dart';
import 'package:music_player/resources/styles/custom_theme.dart';

class ThemeUtils {

  static bool isDarkMode(BuildContext context){
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  static Color getInvertedColor(BuildContext context) {
    if (isDarkMode(context)){
      return CustomTheme(context).light().colorScheme.tertiary;
    } else {
      return CustomTheme(context).dark().colorScheme.tertiary;
    }
  }
}