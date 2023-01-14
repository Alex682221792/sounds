import 'dart:convert';
import 'dart:io';

import 'package:music_player/app/app_state.dart';
import 'package:music_player/app/constant_app.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/models/settings.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/utils/file_util.dart';
import 'package:music_player/utils/settings_utils.dart';

class PlaylistUtils {
  static Future<File> updateDefaultPlaylist() async {
    String trackJson =
        await FileUtil.getContentFile(ConstantApp.ALL_TRACKS_PATH);
    List<Track> existsTracks = (jsonDecode(trackJson) as List<dynamic>)
        .map((e) => Track.fromJson(e))
        .toList()
        .where((element) => element.visible)
        .toList();

    List<String> trackList = existsTracks.map((e) => e.id).toList();
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    List<Playlist> existPlaylist = playlistJson.isEmpty
        ? []
        : (jsonDecode(playlistJson) as List<dynamic>)
            .map((e) => Playlist.fromJson(e))
            .toList();

    existPlaylist.removeWhere(
        (element) => element.id == ConstantApp.ID_DEFAULT_PLAYLIST_KEYMAP);
    existPlaylist.add(Playlist(
        id: ConstantApp.ID_DEFAULT_PLAYLIST_KEYMAP,
        name: "All tracks",
        tracks: trackList));
    return FileUtil.writeFile(
        ConstantApp.PLAYLIST_FILE_PATH, jsonEncode(existPlaylist));
  }

  static void addTrackToPlaylist(String idPlaylist, List<Track> tracks) async {
    List<String> trackList = tracks.map((e) => e.id).toList();
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    List<Playlist> existPlaylist = playlistJson.isEmpty
        ? []
        : (jsonDecode(playlistJson) as List<dynamic>)
            .map((e) => Playlist.fromJson(e))
            .toList();
    Playlist playlist =
        existPlaylist.where((element) => element.id == idPlaylist).first;

    trackList.removeWhere((element) => playlist.tracks.contains(element));
    playlist.tracks.addAll(trackList);
    await FileUtil.writeFile(
        ConstantApp.PLAYLIST_FILE_PATH, jsonEncode(existPlaylist));
  }

  static Future<File> updatePlaylist(Playlist playlist) async {
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    List<Playlist> existPlaylist = playlistJson.isEmpty
        ? []
        : (jsonDecode(playlistJson) as List<dynamic>)
            .map((e) => Playlist.fromJson(e))
            .toList();
    existPlaylist.removeWhere((element) => element.id == playlist.id);
    existPlaylist.add(playlist);
    return FileUtil.writeFile(
        ConstantApp.PLAYLIST_FILE_PATH, jsonEncode(existPlaylist));
  }

  static Future<Playlist?> createPlaylist(
      String name, List<String> tracksIDs) async {
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    List<Playlist> existPlaylist = playlistJson.isEmpty
        ? []
        : (jsonDecode(playlistJson) as List<dynamic>)
            .map((e) => Playlist.fromJson(e))
            .toList();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    Playlist newPlaylist = Playlist(id: id, name: name, tracks: tracksIDs);
    existPlaylist.add(newPlaylist);
    var result = await FileUtil.writeFile(
        ConstantApp.PLAYLIST_FILE_PATH, jsonEncode(existPlaylist));
    if (await result.exists()) {
      return Future(() => newPlaylist);
    }
    return Future(() => null);
  }

  static Future<bool> removePlaylist(List<String> idPlaylist) async {
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    List<Playlist> existPlaylist = playlistJson.isEmpty
        ? []
        : (jsonDecode(playlistJson) as List<dynamic>)
            .map((e) => Playlist.fromJson(e))
            .toList();
    existPlaylist.removeWhere((element) => idPlaylist.contains(element.id));
    await FileUtil.writeFile(
        ConstantApp.PLAYLIST_FILE_PATH, jsonEncode(existPlaylist));
    return Future(() => true);
  }

  static Future<Playlist> getCurrentPlaylist() async {
    Settings settings = await SettingsUtils.readSettings();
    return PlaylistUtils.getPlaylistById(settings.currentPlaylist);
  }

  static Future<Playlist> getPlaylistById(String idPlaylist) async {
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    List<Playlist> existPlaylist = playlistJson.isEmpty
        ? []
        : (jsonDecode(playlistJson) as List<dynamic>)
            .map((e) => Playlist.fromJson(e))
            .toList();
    return existPlaylist.firstWhere((element) => element.id == idPlaylist);
  }

  static Future<Track?> getNextTrackPlaylist() async {
    return getTrackNextOrPrev(true);
  }

  static Future<Track?> getPreviousTrackPlaylist() async {
    return getTrackNextOrPrev(false);
  }

  static Future<Track?> getTrackNextOrPrev(bool nextTrack) async {
    Settings settings = await SettingsUtils.readSettings();
    Playlist playlist;
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);

    if (settings.currentPlaylist.isNotEmpty) {
      playlist = AppState.playlist ??
          (jsonDecode(playlistJson) as List<dynamic>)
              .map((e) => Playlist.fromJson(e))
              .toList()
              .where((element) => element.id == settings.currentPlaylist)
              .first;

      int currentIndex = playlist.tracks
          .lastIndexWhere((element) => element == (AppState.track?.id ?? ""));
      int index = 0;
      if (nextTrack) {
        index =
            currentIndex < (playlist.tracks.length - 1) ? currentIndex + 1 : 0;
      } else {
        index =
            currentIndex > 0 ? currentIndex - 1 : (playlist.tracks.length - 1);
      }
      //AppState.playlist = playlist;
      return await getTrackById(playlist.tracks[index]);
    }
    return null;
  }

  static Future<Track> getTrackById(String id) async {
    String trackJson =
        await FileUtil.getContentFile(ConstantApp.ALL_TRACKS_PATH);

    List<Track> existsTracks = (jsonDecode(trackJson) as List<dynamic>)
        .map((e) => Track.fromJson(e))
        .toList();
    return existsTracks.where((element) => element.id == id).first;
  }

  static Future<List<Track>> getTrackByIdList(List<String> ids) async {
    String trackJson =
        await FileUtil.getContentFile(ConstantApp.ALL_TRACKS_PATH);

    List<Track> existsTracks = (jsonDecode(trackJson) as List<dynamic>)
        .map((e) => Track.fromJson(e))
        .toList();
    existsTracks
        .retainWhere((element) => ids.contains(element.id) && element.visible);
    return existsTracks;
  }

  static Future<List<Playlist>> getAllPlaylist() async {
    String playlistJson =
        await FileUtil.getContentFile(ConstantApp.PLAYLIST_FILE_PATH);
    return (jsonDecode(playlistJson) as List<dynamic>)
        .map((e) => Playlist.fromJson(e))
        .toList();
  }

  static Future<List<Track>> getAllTracks() async {
    String trackJson =
        await FileUtil.getContentFile(ConstantApp.ALL_TRACKS_PATH);
    return (jsonDecode(trackJson) as List<dynamic>)
        .map((e) => Track.fromJson(e))
        .toList()
        .where((element) => element.visible)
        .toList();
  }

  static Future<File> removeTrackById(String id) async {
    String trackJson =
        await FileUtil.getContentFile(ConstantApp.ALL_TRACKS_PATH);

    List<Track> existsTracks = (jsonDecode(trackJson) as List<dynamic>)
        .map((e) => Track.fromJson(e))
        .toList();
    existsTracks.firstWhere((element) => element.id == id).visible = false;
    await removeTrackAtAllPlaylist(id);
    return FileUtil.writeFile(
        ConstantApp.ALL_TRACKS_PATH, jsonEncode(existsTracks));
  }

  static Future<File> removeTrackAtAllPlaylist(String trackId) async {
    var playlists = await getAllPlaylist();
    playlists.forEach((element) {
      element.tracks.removeWhere((track) => trackId == track);
    });
    return FileUtil.writeFile(
        ConstantApp.PLAYLIST_FILE_PATH, jsonEncode(playlists));
  }
}
