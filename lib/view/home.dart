import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/providers/ads_provider.dart';
import 'package:music_player/providers/menu_provider.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/button_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/services/audio_finder_service.dart';
import 'package:music_player/utils/player_utils.dart';
import 'package:music_player/view/audio_finder.dart';
import 'package:music_player/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 2), () {
        if (!AppState.hasBeenRanSearchService) {
          AppState.hasBeenRanSearchService = true;
          AudioFinderService.initializeService(context);
        }
      });
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdsProvider>(create: (_) => AdsProvider()),
        ChangeNotifierProvider<PlayerProvider>(create: (_) => PlayerProvider()),
        ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
        ChangeNotifierProvider<PlaylistProvider>(
            create: (_) => PlaylistProvider())
      ],
      child: Scaffold(
        key: AppState.homeKey,
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
              bottom: 0,
              child: Consumer<MenuProvider>(builder: (context, menu, child) {
                PlayerUtils.initCustomAudioHandler();
                if (!AppState.isHomeCurrentView) {
                  AppState.isHomeCurrentView = true;
                  AppState.audioHandler?.resetProvider();
                }
                return menu.currentView;
              })),
          Positioned.fill(bottom: 0, child: BottomBar()),

        ]),
      ),
    );
  }

  Widget iconButton(Function() action, {context: BuildContext, icon: String}) {
    double size = Dimens.smallIcon * 1.25;
    return TextButton(
        style: ButtonStyles.circleButtonStyle(size),
        onPressed: action,
        child: SvgPicture.asset("assets/icons/$icon.svg",
            color: Theme.of(context).colorScheme.tertiary, height: size));
  }

  void openFileExplorer(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const AudioFinder();
        });
  }


}
