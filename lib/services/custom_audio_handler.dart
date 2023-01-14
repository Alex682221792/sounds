import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:provider/provider.dart';

class CustomAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  PlayerProvider? _playerProvider;

  CustomAudioHandler() {
    initializeProvider();
  }

  void resetProvider() {
    _playerProvider = null;
    initializeProvider();
  }

  void initializeProvider() {
    BuildContext? context = AppState.isHomeCurrentView
        ? AppState.homeKey.currentContext
        : AppState.playlistDetailsKey.currentContext;

    if (context != null) {
      _playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      AppState.player.getCurrentPosition().then((value) => AppState
          .audioHandler?.playbackState
          .add(_transformEvent(AppState.player, false)));
      Timer(Duration(milliseconds: 100), () {
        _playerProvider?.updateListeners();
      });
    }
  }

  Future<void> play() async {
    _playerProvider?.resumeTrack();
  }

  Future<void> pause() async {
    _playerProvider?.pauseTrack();
  }

  Future<void> stop() async {
    _playerProvider?.stopTrack();
  }

  Future<void> skipToNext() async {
    _playerProvider?.playNextTractPlaylist();
  }

  Future<void> skipToPrevious() async {
    _playerProvider?.playPreviousTrackPlaylist();
  }

  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
  }

  void updatePlaybackState(bool isPlaying) {
    AppState.audioHandler?.playbackState
        .add(AppState.audioHandler!.playbackState.value.copyWith(
      playing: false,
    ));
    var controls = AppState.audioHandler?.playbackState.value.controls;
    controls?.removeAt(1);
    if (isPlaying) {
      controls?.insert(1, MediaControl.pause);
    } else {
      controls?.insert(1, MediaControl.play);
    }
    AppState.player.getCurrentPosition().then((value) => AppState
        .audioHandler?.playbackState
        .add(AppState.audioHandler!.playbackState.value
            .copyWith(playing: true, controls: controls!)));
  }

  PlaybackState _transformEvent(AudioPlayer _player, bool isPlaying) {
    var dynamicControl = MediaControl.play;
    if (isPlaying) {
      dynamicControl = MediaControl.pause;
    }
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        dynamicControl,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: [0, 1, 3],
      playing: isPlaying,
      updatePosition: Duration(microseconds: 0),
      speed: 1,
      queueIndex: 0,
    );
  }

  void updateDataNotification(Track track) {
    var _item = MediaItem(
      id: track.id,
      album: "",
      title: track.name,
      artist: track.artist,
      duration: Duration(milliseconds: track.duration),
      //artUri: Uri.parse('https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    );
    mediaItem.add(_item);
  }
}
