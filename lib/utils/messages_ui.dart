import 'package:flutter/material.dart';

class MessagesUI {
  static void showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}