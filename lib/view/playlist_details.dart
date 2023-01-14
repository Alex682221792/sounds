import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/button_styles.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/utils/themes_utils.dart';
import 'package:music_player/widgets/custom_nav_bar.dart';
import 'package:music_player/widgets/mini_square_button.dart';
import 'package:music_player/widgets/playlist_bottom_bar.dart';
import 'package:music_player/widgets/track_item.dart';
import 'package:music_player/widgets/track_item_selectable.dart';
import 'package:provider/provider.dart';

class PlaylistDetails extends StatelessWidget {
  PlaylistDetails({Key? key}) : super(key: key);
  PlaylistProvider? _playlistProvider;

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: onPopCallback,
        child:MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerProvider>(
              create: (_) => PlayerProvider()),
          ChangeNotifierProvider<PlaylistProvider>(
              create: (_) => PlaylistProvider())
        ],
        child: FutureBuilder<Playlist>(
          key: UniqueKey(),
          future: PlaylistUtils.getCurrentPlaylist(),
          builder: (context, snapshot) {
            initializePlayerProvider(context);
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            Playlist playlist = snapshot.data!;
            return Scaffold(
                key: AppState.playlistDetailsKey,
                appBar: CustomNavBar.getBar(playlist.name, () {
                  onPopCallback();
                  Navigator.pop(context);
                }, context),
                body: Column(
                  children: [
                    topBarActions(context, playlist),
                    SizedBox(height: Dimens.normalPadding),
                    const Divider(height: 1),
                    listItems(context, playlist),
                    PlaylistBottomBar()
                  ],
                ));
          },
        )));
  }

  Future<bool> onPopCallback() {
    Timer(Duration(milliseconds: 200), () {
      AppState.isHomeCurrentView = true;
      AppState.audioHandler?.resetProvider();
    });
    return Future.value(true);
  }

  Widget listItems(BuildContext context, Playlist playlist) {
    return Expanded(
        child: FutureBuilder<List<Track>>(
            future: PlaylistUtils.getTrackByIdList(playlist.tracks),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              AppState.isHomeCurrentView = false;
              AppState.audioHandler?.resetProvider();
              var tracks = snapshot.data!;
              return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tracks.length,
                      itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 0),
                          child: TrackItem(tracks[index], playlist.id,
                              callback: () {
                            //Navigator.of(context).pushNamed(Routes.PLAYER);
                          }))));
            }));
  }

  Widget iconButton(
      {required Function() action,
      required BuildContext context,
      required String icon,
      Color? color}) {
    double size = Dimens.smallIcon * 1.5;

    return MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minWidth: size,
        //style: ButtonStyles.squareRoundedButtonStyle(size, color),
        onPressed: action,
        child: SvgPicture.asset("assets/icons/" + icon + ".svg",
            color: Colors.white, height: size * 0.5));
  }

  Widget topBarActions(BuildContext context, Playlist playlist) {
    return Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(children: [
              Expanded(child: Text("${playlist.tracks.length} Tracks")),
              MiniSquareButton(
                icon: "assets/icons/plus.svg",
                callback: () {
                  showModalBottomSheet<void>(
                      elevation: 3,
                      isScrollControlled: true,
                      barrierColor: Colors.white12,
                      isDismissible: false,
                      context: context,
                      builder: (_) {
                        return ListenableProvider.value(
                            value: _playlistProvider,
                            child: trackFinder(playlist, context));
                      });
                },
                size: 30,
              )
            ])));
  }

  Widget trackFinder(Playlist playlist, BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.75;
    return FractionallySizedBox(
        heightFactor: MediaQuery.of(context).viewInsets.bottom != 0 ? 0.9 : 0.7,
        child: Scaffold(
            body: SizedBox(
                height: height,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            gradient: Gradients.checkPointBg(context)),
                        height: Dimens.heightBottomBar,
                        child: Center(
                          child: Text("Track list",
                              style: TextStyles.normalTextStyle),
                        )),
                    searchBox(context),
                    Expanded(child: trackList(playlist)),
                    Container(
                        height: Dimens.heightBottomBar * 1.5,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () =>
                                      saveChange(playlist, context),
                                  style: ButtonStyles.accentTextButton(context),
                                  child: Text("Continue")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"))
                            ]))
                  ],
                ))));
  }

  void saveChange(Playlist playlist, BuildContext context) {
    PlaylistUtils.updatePlaylist(playlist).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("¡Playlist updated!"),
            )));
    Navigator.pop(context);
    (context as Element).reassemble();
  }

  Widget searchBox(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextField(
            decoration: InputDecoration(
                hintText: "Buscar por nombre...",
                border: InputBorder.none,
                icon: SvgPicture.asset("assets/icons/search.svg",
                    width: Dimens.smallIcon,
                    color: ThemeUtils.getInvertedColor(context))),
            onChanged: (value) {
              _playlistProvider!.updateTrackCurrentPlaylistFilters(value);
            }));
  }

  Widget trackList(Playlist playlist) {
    return FutureBuilder<List<Track>>(
        future: PlaylistUtils.getAllTracks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var tracks = snapshot.data!;
          return Consumer<PlaylistProvider>(
              builder: (context, playlistPrvdr, child) {
            var tracksToShow = tracks
                .where((element) => element.name
                    .toLowerCase()
                    .contains(playlistPrvdr.trackListFilter.toLowerCase()))
                .toList();
            return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tracksToShow.length,
                    itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(top: 0),
                        child: TrackItemSelectable(
                            tracksToShow[index], playlist.tracks))));
          });
        });
  }

  void initializePlayerProvider(BuildContext context) {
    _playlistProvider = _playlistProvider ??
        Provider.of<PlaylistProvider>(context, listen: false);
  }
}
