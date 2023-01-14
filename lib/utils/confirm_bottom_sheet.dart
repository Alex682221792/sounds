import 'package:flutter/material.dart';
import 'package:music_player/resources/styles/button_styles.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';

class ConfirmBottomSheet {
  Function callbackOk;
  Function? callbackCancel;
  String message;

  ConfirmBottomSheet(
      {required this.message, required this.callbackOk, this.callbackCancel});

  Future<bool?> showDialog(BuildContext context) {
    return showModalBottomSheet<bool>(
        backgroundColor: Colors.transparent,
        elevation: 3,
        isScrollControlled: true,
        barrierColor: Colors.white12,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return _uiBuilder(context);
        });
  }

  Widget _uiBuilder(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      padding: EdgeInsets.all(Dimens.normalPadding),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.normalRadius),
              topRight: Radius.circular(Dimens.normalRadius))),
      child: Column(
        children: [
          Icon(Icons.warning_amber,
              color: Theme.of(context).colorScheme.secondary,
              size: Dimens.normalIcon),
          SizedBox(height: Dimens.normalPadding),
          Expanded(child: Text(message, style: TextStyles.normalTextStyle)),
          ButtonBar(
            children: [
              TextButton(
                  style: ButtonStyles.accentTextButton(context),
                  onPressed: () {
                    callbackOk.call();
                    Navigator.pop(context, true);
                  },
                  child: Text("Accept", style: TextStyles.normalTextStyle)),
              TextButton(
                style: ButtonStyles.secondaryOption(context),
                  onPressed: () {
                    callbackCancel?.call();
                    Navigator.pop(context, false);
                  },
                  child: Text("Cancel", style: TextStyles.normalTextStyle))
            ],
          )
        ],
      ),
    );
  }
}
