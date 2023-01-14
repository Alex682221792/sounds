import 'package:flutter/cupertino.dart';
import 'package:music_player/view/home.dart';
import 'package:music_player/view/info_app.dart';
import 'package:music_player/view/player.dart';
import 'package:music_player/view/playlist_details.dart';

class Routes {
  static const String HOME = "/home";
  static const String PLAYLIST_DETAILS = "/playlist_details";
  static const String INFO_APP = "/info_app";
  static const String PLAYER = "/player";

  static Map<String, WidgetBuilder> paths = {
    HOME: (context) => const Home(),
    PLAYER: (context) => Player(),
    INFO_APP: (context) => const InfoApp(),
    PLAYLIST_DETAILS: (context) => PlaylistDetails()
  };
}