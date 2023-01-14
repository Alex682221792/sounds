import 'package:flutter/material.dart';
import 'package:music_player/resources/values/dimens.dart';

class TextStyles {
  static TextStyle appNameTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).scaffoldBackgroundColor,
        fontSize: Dimens.largeFont,
        fontWeight: FontWeight.bold,
        fontFamily: "Montserrat");
  }

  static TextStyle titleTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: Dimens.mediumFont,
        fontWeight: FontWeight.bold,
        fontFamily: "Montserrat");
  }

  static TextStyle subtitleTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        fontSize: Dimens.normalFont,
        fontFamily: "Montserrat");
  }

  static TextStyle authorTextStyle =  TextStyle(
        fontSize: Dimens.smallFont,
        fontFamily: "Montserrat");

  static TextStyle audioItemTextStyle = TextStyle(
        color: Colors.black,
        fontSize: Dimens.normalFont,
        fontFamily: "Montserrat");

  static TextStyle playlistItemTitle = TextStyle(
      fontSize: Dimens.normalFont,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat");

  static TextStyle normalTextStyle = TextStyle(
      //color: Colors.black,
      fontSize: Dimens.normalFont,
      fontFamily: "Montserrat");

  static TextStyle mediumTextStyle = TextStyle(
      fontSize: Dimens.mediumFont,
      fontFamily: "Montserrat");

  static TextStyle normalWhiteTextStyle = TextStyle(
    color: Colors.white,
      //fontSize: Dimens.normalFont,
      fontFamily: "Montserrat");

  static TextStyle systemWhiteTextStyle = TextStyle(
      color: Colors.white,
      //fontSize: Dimens.normalFont,
      fontFamily: "Montserrat");

  static TextStyle durationTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: Dimens.normalFont,
        fontFamily: "Montserrat");
  }

  static TextStyle secondaryStrongTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: Dimens.normalFont,
        fontFamily: "Montserrat");
  }

  static TextStyle titleAdviceTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: Dimens.mediumFont,
        fontFamily: "Montserrat");
  }

}