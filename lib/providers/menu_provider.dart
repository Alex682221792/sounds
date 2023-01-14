import 'package:flutter/material.dart';
import 'package:music_player/view/customer_summary.dart';
import 'package:music_player/view/playlist_summary.dart';

class MenuProvider extends ChangeNotifier {
  static const String SUMMARY_VIEW = "summary";
  static const String PLAYLIST_VIEW = "playlist";

  Widget? _currentView = null;
  String _currentViewName = SUMMARY_VIEW;

  Widget get currentView => _currentView ?? _getCurrentWidget(SUMMARY_VIEW);

  void updateView(String view) {
    _currentViewName = view;
    _currentView = _getCurrentWidget(view);
    notifyListeners();
  }

  Widget _getCurrentWidget(String view) {
    print("**** view: $view");
    switch(view) {
      case PLAYLIST_VIEW:
        return PlaylistSummary();
      case SUMMARY_VIEW:
      default:
        return CustomerSummary();
    }
  }

  bool isCurrentView(String view) {
    return _currentViewName == view;
  }
}