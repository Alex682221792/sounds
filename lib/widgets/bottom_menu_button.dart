import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/providers/menu_provider.dart';
import 'package:music_player/resources/styles/button_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:provider/provider.dart';

class BottomMenuButton extends StatelessWidget {
  MenuProvider? menuProvider;
  String icon;
  String view;
  BottomMenuButton(this.icon, this.view);

  @override
  Widget build(BuildContext context) {
    double size = Dimens.smallIcon * 1.25;
    return TextButton(
        style: ButtonStyles.circleButtonStyle(size),
        onPressed: () {
          initializeMenuProvider(context);
          return menuProvider?.updateView(view);
        },
        child: SvgPicture.asset("assets/icons/" + icon + ".svg",
            color: Theme.of(context).colorScheme.tertiary, height: size));
  }

  void initializeMenuProvider(BuildContext context) {
    menuProvider = menuProvider ?? Provider.of<MenuProvider>(context, listen: false);
  }
}
