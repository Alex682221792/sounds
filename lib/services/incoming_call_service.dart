import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';

class IncomingCallService {
  static void initialize() {
    PhoneState.phoneStateStream.listen((event) {
      var playerPrvdr = getPlayerProvider();
      switch (event) {
        case PhoneStateStatus.NOTHING:
        case PhoneStateStatus.CALL_ENDED:
          {
            if (playerPrvdr != null && AppState.isPlaying) {
              playerPrvdr.resumeTrack();
            }
            break;
          }
        case PhoneStateStatus.CALL_STARTED:
        case PhoneStateStatus.CALL_INCOMING:
          {
            if (playerPrvdr != null) {
              AppState.isPlaying =
                  playerPrvdr.getPlayerStatus() == PlayerState.playing;
              playerPrvdr.pauseTrack();
            }
            break;
          }
        case null:{break;}
      }
    });
  }

  static PlayerProvider? getPlayerProvider() {
    BuildContext? context = AppState.isHomeCurrentView
        ? AppState.homeKey.currentContext
        : AppState.playlistDetailsKey.currentContext;

    if (context != null) {
      return Provider.of<PlayerProvider>(context, listen: false);
    }
    return null;
  }
}
