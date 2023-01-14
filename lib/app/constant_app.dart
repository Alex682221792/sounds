

class ConstantApp {
  static String FAVORITE_FILE_PATH = "favorites.json";
  static String PLAYLIST_FILE_PATH = "playlist.json";
  static String ALL_TRACKS_PATH = "tracks.json";
  static String SETTINGS_PATH = "settings.json";

  static String ALL_TRACKS_KEYMAP = "all_tracks";
  static String ID_DEFAULT_PLAYLIST_KEYMAP = "default_playlist";
  static String NEW_TRACKS_KEYMAP = "new_tracks";
  static String SHOW_NEW_TRACKS_KEYMAP = "show_new_tracks";
  static String SEARCHING_TRACKS_YET_KEYMAP = "searching_tracks_yet";

  static List<String> BASE_EXCLUDED_PATHS = ["/storage/emulated/0/Android",
    "/storage/emulated/0/log","/storage/emulated/0/DCIM"];
  static String URL_BUY_ME_A_COFFEE = "https://www.buymeacoffee.com/encideas";
}