import 'package:flutter/material.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/app/routes.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/settings_utils.dart';
import 'package:music_player/utils/themes_utils.dart';
import 'package:music_player/widgets/main_button.dart';

class PlaylistCard extends StatefulWidget {
  Playlist playlist;
  PlaylistProvider? playlistProvider;
  bool? resetState = false;

  PlaylistCard(this.playlist,
      {this.playlistProvider, this.resetState, super.key});

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  var selectableEnable = false;

  @override
  Widget build(BuildContext context) {
    if (widget.resetState ?? false) {
      setState(() {
        selectableEnable = false;
      });
    }
    return GestureDetector(
        onTap: () {
          if (selectableEnable) {
            widget.playlistProvider?.removeFromChosenList(widget.playlist);
            setState(() {
              selectableEnable = false;
            });
            return;
          }
          if (widget.playlistProvider?.playlistChosen.isNotEmpty ?? false) {
            setState(() {
              selectableEnable = true;
            });
            return;
          }
          SettingsUtils.updateCurrentPlayList(widget.playlist.id)
              .then((value) => openListView(context));
        },
        onLongPress: () {
          widget.playlistProvider?.addToChosenList(widget.playlist);
          setState(() {
            selectableEnable = true;
          });
        },
        child: Container(
            height: double.infinity,
            width: 120,
            margin: EdgeInsets.all(Dimens.smallPadding),
            padding: EdgeInsets.only(
                top: Dimens.normalPadding,
                left: Dimens.smallPadding),
            decoration: BoxDecoration(
                color: ThemeUtils.getInvertedColor(context).withAlpha(selectableEnable ? 40 : 20),
                borderRadius: BorderRadius.circular(Dimens.normalRadius)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Text(widget.playlist.name,
                        style: TextStyles.playlistItemTitle)),
                SizedBox(height: Dimens.normalPadding),
                Divider(
                    height: 2, color: Theme.of(context).colorScheme.secondary),
                SizedBox(height: Dimens.normalPadding),
                /*Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(Icons.music_note_outlined),
                        Expanded(
                            child:
                                Text("${widget.playlist.tracks.length} Tracks"))
                      ],
                    )),*/
                Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.music_note_outlined),
                            Expanded(
                                child:
                                Text("${widget.playlist.tracks.length} Tracks"))
                          ],
                        ),
                        Positioned(
                          top: 0,
                            right: -5,
                            child: SizedBox(
                                height: Dimens.mainButtonSize * 1.15,
                                child: actionIcon()))
                      ],
                    ))
              ],
            )));
  }

  Widget actionIcon() {
    if (selectableEnable) {
      return Icon(
        Icons.check_circle,
        color: Theme.of(context).colorScheme.secondary,
        size: Dimens.mainButtonSize,
      );
    }
    return MainButton(() => openListView(context),
        size: Dimens.mainButtonSize * 1.2, icon: "assets/icons/playlist.svg");
  }

  void openListView(BuildContext context) {
    AppState.playlist = widget.playlist;
    Navigator.pushNamed(context, Routes.PLAYLIST_DETAILS);
  }
}
