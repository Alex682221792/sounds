import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/services/custom_audio_handler.dart';
import 'package:provider/provider.dart';

class PlayerUtils {
  static void initCustomAudioHandler() async {
    AppState.audioHandler ??= await AudioService.init(
      builder: () => CustomAudioHandler(),
      config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.encoding-ideas.sounds',
          androidNotificationChannelName: 'Sounds - Music player'),
    );
  }

  static void initPlayerListeners() async {
    AppState.player.onPlayerComplete.listen((data) {
      BuildContext? context = AppState.homeKey.currentContext;
      if (context != null) {
        Provider.of<PlayerProvider>(context, listen: false)
            .playNextTractPlaylist();
      }
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });
  }
}
