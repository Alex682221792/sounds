import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/app/ad_helper.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/utils/interstitial_ads_utils.dart';
import 'package:music_player/utils/playlist_utils.dart';

class PlayerProvider extends ChangeNotifier {
  AudioPlayer _player = AppState.player;
  PlayerState state = AppState.player.state; //PlayerState.stopped;

  void updateListeners() {
    notifyListeners();
  }

  void playTrack(Track track) {
    AppState.track = track;
    InterstitialAdsUtils().showInterstitialAd(
        adId: AdHelper.interstitialAdUnitId,
        onDismissed: () {
          _player.play(DeviceFileSource(track.path)).then((value) {
            state = PlayerState.playing;
            notifyListeners();
            AppState.audioHandler?.updateDataNotification(track);
            AppState.audioHandler?.updatePlaybackState(true);
          });
        },
        onShowed: () => {
          _player.pause()
        });
  }

  void setPosition(Duration duration) {
    _player.play(DeviceFileSource(AppState.track!.path), position: duration);
    notifyListeners();
  }

  Track? getCurrentTrack() {
    return AppState.track;
  }

  void stopTrack() {
    _player.stop();
    state = PlayerState.stopped;
    notifyListeners();
    AppState.audioHandler?.updatePlaybackState(false);
  }

  void pauseTrack() {
    _player.pause();
    state = PlayerState.paused;
    notifyListeners();
    AppState.audioHandler?.updatePlaybackState(false);
  }

  void resumeTrack() {
    if (state == PlayerState.paused) {
      _player.resume();
      state = PlayerState.playing;
      notifyListeners();
    } else {
      playNextTractPlaylist();
    }
    AppState.audioHandler?.updatePlaybackState(true);
  }

  void playNextTractPlaylist() async {
    BuildContext? context = AppState.homeKey.currentContext;
    if (context != null) {
      Track? nextTrack = await PlaylistUtils.getNextTrackPlaylist();
      if (nextTrack != null) {
        playTrack(nextTrack);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Track no encontrado"),
        ));
      }
    }
  }

  void playPreviousTrackPlaylist() async {
    BuildContext? context = AppState.homeKey.currentContext;
    if (context != null) {
      Track? track = await PlaylistUtils.getPreviousTrackPlaylist();
      if (track != null) {
        playTrack(track);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Track no encontrado"),
        ));
      }
    }
  }

  PlayerState getPlayerStatus() {
    state = state == PlayerState.stopped ? AppState.player.state : state;
    return state;
  }

  bool matchTrack(Track track) {
    if (AppState.track != null) {
      return AppState.track!.id == track.id;
    }
    return false;
  }
}
