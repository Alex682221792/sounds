import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/themes_utils.dart';

class CustomNavBar {
  static PreferredSize getBar(
      String title, Function? callback, BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(Dimens.heightAppBar * 1.15),
        // here the desired height
        child: AppBar(
          foregroundColor: ThemeUtils.getInvertedColor(context),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
              padding: EdgeInsets.only(
                  right: (Dimens.smallPadding * 2) + Dimens.smallIcon * 2),
              child: Center(
                  child: Text(title, style: TextStyles.mediumTextStyle))),
          leading: Container(
              padding: EdgeInsets.all(Dimens.smallPadding),
              width: Dimens.smallIcon,
              height: Dimens.smallIcon,
              child: _backButton(callback, context)),
        ));
  }

  static Widget _backButton(Function? callback, BuildContext context) {
    if (callback != null) {
      return TextButton(
          onPressed: () {
            callback.call();
          },
          child: SvgPicture.asset("assets/icons/back.svg",
              color: ThemeUtils.getInvertedColor(context), height: Dimens.largeFont));
    }
    return SizedBox();
  }
}
