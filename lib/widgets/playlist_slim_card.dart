import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/app/routes.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/settings_utils.dart';
import 'package:music_player/widgets/main_button.dart';

class PlaylistSlimCard extends StatefulWidget {
  Playlist playlist;
  PlaylistProvider? playlistProvider;
  bool? resetState = false;

  PlaylistSlimCard(this.playlist,
      {this.playlistProvider, this.resetState, super.key});

  @override
  State<PlaylistSlimCard> createState() => _PlaylistSlimCardState();
}

class _PlaylistSlimCardState extends State<PlaylistSlimCard> {
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
        child: Container(
            height: double.infinity,
            width: 80,
            margin: EdgeInsets.all(Dimens.smallPadding),
            padding: EdgeInsets.only(
                top: Dimens.normalPadding,
                left: Dimens.smallPadding,
                right: Dimens.smallPadding),
            decoration: BoxDecoration(
                color: _getRandomColor(),//ThemeUtils.getInvertedColor(context).withAlpha(20),
                borderRadius: BorderRadius.circular(Dimens.normalRadius)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: RotatedBox(
                        quarterTurns: 45,
                        child: Text(widget.playlist.name,
                            style: TextStyles.playlistItemTitle))),
                SizedBox(height: Dimens.normalPadding),
                Divider(
                    height: 2, color: Theme.of(context).colorScheme.secondary),
                SizedBox(height: Dimens.normalPadding),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(Icons.music_note_outlined, size: Dimens.smallIcon),
                        Expanded(
                            child:
                                FittedBox(fit: BoxFit.fitWidth,
                                child: Text("${widget.playlist.tracks.length} Tracks")))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 0,
                            child: SizedBox(
                                width: 80 - (Dimens.smallPadding * 2),
                                height: Dimens.mainButtonSize * 1.15,
                                child: Center(child: actionIcon())))
                      ],
                    ))
              ],
            )));
  }

  Color _getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFAAAA).toInt()).withOpacity(0.2);
  }

  Widget actionIcon() {
    return MainButton(() => null,
        size: Dimens.mainButtonSize * 1.2, icon: "assets/icons/playlist.svg");
  }

  void openListView(BuildContext context) {
    AppState.playlist = widget.playlist;
    Navigator.pushNamed(context, Routes.PLAYLIST_DETAILS);
  }
}
