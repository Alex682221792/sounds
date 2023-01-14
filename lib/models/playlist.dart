import 'dart:convert';

class Playlist {
  final String id;
  String name;
  final List<String> tracks;

  Playlist({required this.id, required this.name, required this.tracks});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
        id: json['id'] as String,
        name: json['name'] as String,
        tracks: (jsonDecode(json['tracks']) as List<dynamic>)
            .map((e) => e.toString())
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "tracks": jsonEncode(tracks)};
  }
}
