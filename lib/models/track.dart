class Track {
  final String id;
  final String name;
  final String artist;
  final String path;
  final int duration; //milliseconds
  bool visible;

  Track(
      {required this.id,
      required this.name,
      required this.artist,
      required this.path,
      required this.duration,
      required this.visible});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
        id: json['id'].toString(),
        name: json['name'] as String,
        artist: json['artist'] as String,
        path: json['path'] as String,
        duration: json['duration'] as int,
        visible: json['visible'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "artist": artist,
      "path": path,
      "duration": duration,
      "visible": visible
    };
  }
}
