import 'dart:convert';
import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player/app/constant_app.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/services/audio_finder_service.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioFinderUtils {
  var files;

  static Future<List<File>> getMp3Files(
      List<String> excludedPaths, bool updateAudioFinderService) async {
    if (await Permission.storage.status.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
      var root = storageInfo[0].rootDir;
      root = "/storage/emulated/0/Download";
      List<String> ignoredPaths = []
        ..addAll(ConstantApp.BASE_EXCLUDED_PATHS)
        ..addAll(excludedPaths);
      return _searchMp3File(
          root, false, ignoredPaths, updateAudioFinderService);
    }

    return [];
  }

  static Future<List<File>> _searchMp3File(String pathFolder, bool recursive,
      List<String> excludedPath, bool updateAudioFinderService) async {
    List<File> mp3List = [];
    try {
      if (pathFolder.split("/").last.startsWith(".")) {
        return mp3List;
      }
      Directory dir = Directory(pathFolder);
      List<FileSystemEntity> _files =
          dir.listSync(recursive: recursive, followLinks: false);
      for (FileSystemEntity entity in _files) {
        String path = entity.path;
        File _file = File(path);
        if (!excludedPath.contains(path)) {
          if (_file.existsSync()) {
            if (path.endsWith('.mp3')) {
              mp3List.add(_file);
              if (updateAudioFinderService) {
                AudioFinderService.addAndUpdateTrackList(
                    [await getTrack(_file, _files.indexOf(entity).toString())], true);
              }
            }
          } else if (!recursive) {
            List<File> mp3ListSubPath = await _searchMp3File(
                path, true, excludedPath, updateAudioFinderService);
            mp3List.addAll(mp3ListSubPath);
          }
        }
      }
    } catch (ex) {
      print("***** error");
      print(ex);
    }
    //print("********* All mp3 at $pathFolder");
    mp3List.forEach((element) {
      print(element.path);
    });
    return mp3List;
  }

  static Future<Track> getTrack(File file, String idPostfix) async {
    final metadata = await MetadataRetriever.fromFile(file);
    String id = DateTime.now().millisecondsSinceEpoch.toString() +idPostfix;
    String defaultName = file.path.split("/").last.split(".").first;
    return Track(
        id: id,
        name: metadata.trackName ?? defaultName,
        artist: metadata.albumArtistName ?? "",
        path: file.path,
        duration: metadata.trackDuration ?? 0,
        visible: true);
  }

  static void showMetadata(Track track) async {
    File file = File(track.path);
    final metadata = await MetadataRetriever.fromFile(file);
    print(jsonEncode(metadata));
  }

  static String getDuration(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (((seconds % 60))).floor();
    int hours = (minutes / 60).floor();
    return "${hours == 0 ? "" : "$hours:"}"
        "${hours == 0 ? minutes : (minutes % (hours * 60)).floor()}:"
        "${remainingSeconds.toString().padLeft(2, "0")}";
  }
}
