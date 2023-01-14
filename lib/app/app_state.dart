import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../services/custom_audio_handler.dart';

class AppState{

  static AudioPlayer player = AudioPlayer();
  static CustomAudioHandler? audioHandler;
  static Track? track;
  static Playlist? playlist;
  static List<Track> lastTrackList = [];

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey homeKey = GlobalKey();
  static GlobalKey playlistDetailsKey = GlobalKey();
  static bool hasBeenRanSearchService = false;
  /*static GlobalKey homeGlobalKey() {
   return homeKey;
  }*/
  static BuildContext? context;
  static bool isHomeCurrentView = true;
  static bool isPlaying = false;
  static int tapsToShowBanner = 15;
  static int counterTapsBanner = 0;
  static bool flagCoachTutorial = true;
}