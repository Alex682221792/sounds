import 'package:flutter/material.dart';
import 'package:music_player/utils/HexColor.dart';

class CustomTheme {
  BuildContext context;

  CustomTheme(this.context);

  ThemeData light() {
    return ThemeData(
        primaryColor: HexColor("#613F9E"),
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.light(
            primary: HexColor("#653392"),
            secondary: HexColor("#EE6AA7"),
            tertiary: Colors.white));
  }

  ThemeData dark() {
    return ThemeData(
        primaryColor: HexColor("#51488E"),
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.dark(
            primary: HexColor("#653392"),
            secondary: HexColor("#EE6AA7"),
            tertiary: Colors.black));
  }
}
