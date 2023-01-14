import 'dart:io';
import 'package:music_player/app/constant_app.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> readFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  static Future<String> getContentFile(String filename) async {
     File file = await readFile(filename);
     if(!file.existsSync()){
       file = await file.create(recursive: true);
//       file = await writeFile(filename, "");
//       return getContentFile(filename);
     }
     return file.readAsString();
  }

  static Future<File> writeFile(String filename, String content) async {
    //print("************ writeFile: content: ${content}");
    final file = await readFile(filename);
    //print("************ writeFile: PATH: ${file.path}");
    return file.writeAsString(content);
  }

  static Future<bool> createAppFiles() async{
    (await readFile(ConstantApp.PLAYLIST_FILE_PATH)).create(recursive: true);
    (await readFile(ConstantApp.ALL_TRACKS_PATH)).create(recursive: true);
    (await readFile(ConstantApp.SETTINGS_PATH)).create(recursive: true);
    return Future(() => true);
  }
}