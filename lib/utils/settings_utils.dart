import 'dart:convert';
import 'dart:io';

import 'package:music_player/app/constant_app.dart';
import 'package:music_player/models/settings.dart';
import 'package:music_player/utils/file_util.dart';

class SettingsUtils {
  static Future<Settings> readSettings() async {
    String settingsJson =
        await FileUtil.getContentFile(ConstantApp.SETTINGS_PATH);
    Settings settings = settingsJson.isEmpty
        ? Settings(
            currentPlaylist: "",
            currentTrack: "",
            aleatory: false,
            loop: false,
            flagExplorer: true)
        : Settings.fromJson(jsonDecode(settingsJson));
    return settings;
  }

  static Future<File> writeSettings(Settings settings) async {
    return FileUtil.writeFile(ConstantApp.SETTINGS_PATH, jsonEncode(settings));
  }

  static Future<bool> updateCurrentPlayList(String currentPlaylistId) async {
    Settings settings = await readSettings();
    var result = await writeSettings(Settings(
        currentPlaylist: currentPlaylistId,
        currentTrack: settings.currentTrack,
        aleatory: settings.aleatory,
        loop: settings.loop,
        flagExplorer: settings.flagExplorer));
    return result.exists();
  }

  static Future<bool> updateTutorialFlag(bool flagExplorer) async {
    Settings settings = await readSettings();
    var result = await writeSettings(Settings(
        currentPlaylist: settings.currentPlaylist,
        currentTrack: settings.currentTrack,
        aleatory: settings.aleatory,
        loop: settings.loop,
        flagExplorer: flagExplorer));
    return result.exists();
  }
}
