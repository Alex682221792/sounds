import 'package:flutter/material.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/utils/playlist_utils.dart';

class PlaylistProvider extends ChangeNotifier {
  List<Playlist> playlist = [];
  List<Playlist> filteredPlaylist = [];
  List<Playlist> playlistChosen = [];
  bool filtering = false;
  String trackListFilter = "";

  void updatePlaylistSubscribers() {
    PlaylistUtils.getAllPlaylist().then((value) {
      playlist = value;
      notifyListeners();
    });
  }

  void addToChosenList(Playlist playlist) {
    playlistChosen.add(playlist);
    notifyListeners();
  }

  void removeFromChosenList(Playlist playlist) {
    playlistChosen.remove(playlist);
    notifyListeners();
  }

  void clearChosenList() {
    playlistChosen.clear();
    notifyListeners();
  }

  void cleanUpChosenPlaylist() async {
    PlaylistUtils.removePlaylist(playlistChosen.map((e) => e.id).toList())
        .then((value) {
      playlistChosen.clear();
      updatePlaylistSubscribers();
    });
  }

  void filterPlaylistByNameAndRefresh(String name) {
    filtering = name.isNotEmpty;
    filteredPlaylist = playlist
        .where((element) =>
            element.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void updateTrackCurrentPlaylistFilters(String nameToSearch) {
    trackListFilter = nameToSearch;
    notifyListeners();
  }
}
