class Settings {
  final String currentPlaylist;
  final String currentTrack;
  final bool aleatory;
  final bool loop;
  bool flagExplorer = true;

  Settings(
      {required this.currentPlaylist,
      required this.currentTrack,
      required this.aleatory,
      required this.loop,
      required this.flagExplorer});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
        currentPlaylist: json['currentPlaylist'] as String,
        currentTrack: json['currentTrack'] as String,
        aleatory: json['aleatory'] as bool,
        loop: json['loop'] as bool,
        flagExplorer: json['flagExplorer'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPlaylist': currentPlaylist,
      'currentTrack': currentTrack,
      'aleatory': aleatory,
      'loop': loop,
      'flagExplorer': flagExplorer
    };
  }
}
