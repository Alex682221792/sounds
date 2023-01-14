import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/app/constant_app.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/utils/file_util.dart';
import 'package:music_player/utils/audio_finder_utils.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:provider/provider.dart';

//@pragma('vm:entry-point')
class AudioFinderService {
  static String UPDATE_STATE_KEY = "update";
  static String NEW_TRACKS_UPDATE_STATE_KEY = "update_new_tracks";
  static List<Track> _tracks = [];
  static bool _flagShowNewTrackList = false;
  static ServiceInstance? _service;

  static Future<void> initializeService(BuildContext context) async {

    AppState.context = context;

    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: AudioFinderService.onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: _onIosBackground,
      ),
    );
    service.startService();
  }

  // to ensure this is executed
  // run app from xcode, then from xcode menu, select Simulate Background Fetch
  static bool _onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    print('FLUTTER BACKGROUND FETCH');

    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    await FileUtil.createAppFiles();
    _service = service;
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // bring to foreground
//    Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Sounds - Music Player",
        content: "Looking for tracks on device."
      );
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    //obteniendo tracks cargados en inicializaciones previas
    String trackJson =
        await FileUtil.getContentFile(ConstantApp.ALL_TRACKS_PATH);
    List<Track> existsTracks = trackJson.isEmpty
        ? []
        : (jsonDecode(trackJson) as List<dynamic>)
            .map((e) => Track.fromJson(e))
            .toList();
    List<Track> existsTracksVisible =
        existsTracks.where((element) => element.visible).toList();
    addAndUpdateTrackList(existsTracksVisible, true);

    List<String> pathsToExclude = existsTracks.map((e) => e.path).toList();
    List<File> newFiles =
        await AudioFinderUtils.getMp3Files(pathsToExclude, false);

    List<Track> newTracks = await Future.wait(newFiles
        .map(
            (e) => AudioFinderUtils.getTrack(e, newFiles.indexOf(e).toString()))
        .toList());
    _flagShowNewTrackList = !existsTracks.isEmpty;
    _updateNewTracks(newTracks);
    //actualización de tracks almacenados en json
    existsTracks.addAll(newTracks);
    await FileUtil.writeFile(
        ConstantApp.ALL_TRACKS_PATH, jsonEncode(existsTracks));
    //_updateTrackList(false);
    existsTracksVisible.addAll(newTracks);
    addAndUpdateTrackList(existsTracksVisible, false);
    PlaylistUtils.updateDefaultPlaylist().then((value) {
      if (AppState.context != null) {
        Provider.of<PlaylistProvider>(AppState.context!, listen: false)
            .updatePlaylistSubscribers();
      }
    }).whenComplete(() {
      service.stopSelf();
      print('Done!');
    });

    //service.stopSelf();
    //   });
  }

  /// agrega tracks a la lista actual y notifica la actualización
  static void addAndUpdateTrackList(List<Track> tracks, bool searching) {
    _tracks.addAll(tracks);
    _updateTrackList(searching);
  }

  /// notifica a los consumers sobre los cambios en la lista de tracks
  static void _updateTrackList(bool searching) {
    _service?.invoke(
      UPDATE_STATE_KEY,
      {
        ConstantApp.ALL_TRACKS_KEYMAP: _tracks,
        ConstantApp.SEARCHING_TRACKS_YET_KEYMAP: searching,
      },
    );
  }

  static void _updateNewTracks(List<Track> tracks) {
    _service?.invoke(
      NEW_TRACKS_UPDATE_STATE_KEY,
      {
        ConstantApp.NEW_TRACKS_KEYMAP: tracks,
        ConstantApp.SHOW_NEW_TRACKS_KEYMAP: _flagShowNewTrackList
      },
    );
  }
}
