import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/providers/playlist_provider.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/audio_finder_utils.dart';
import 'package:music_player/utils/confirm_bottom_sheet.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/utils/settings_utils.dart';
import 'package:music_player/utils/themes_utils.dart';
import 'package:music_player/widgets/main_button.dart';
import 'package:provider/provider.dart';

class TrackItem extends StatelessWidget {
  final Track track;
  final String playlistId;
  final PlayerProvider? playerProvider;
  final Function()? callback;

  TrackItem(this.track, this.playlistId,
      {this.callback, this.playerProvider});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      child: GestureDetector(
          onTap: () {
            callback?.call();
          },
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Dimens.normalPadding,
                  vertical: Dimens.smallPadding),
              padding: EdgeInsets.all(Dimens.normalPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.normalRadius),
                  color: ThemeUtils.getInvertedColor(context)
                      .withAlpha(Dimens.alphaOverlay)),
              child: Center(
                  child: Row(children: [
                Container(
                    margin: EdgeInsets.only(right: Dimens.smallPadding),
                    height: Dimens.heightAudioItem,
                    child: button(context)),
                Expanded(
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: Dimens.smallPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(track.name),
                          Text(track.artist, style: TextStyles.authorTextStyle),
                        ],
                      )),
                ),
                Center(
                    child: Text(AudioFinderUtils.getDuration(track.duration),
                        style: TextStyles.durationTextStyle(context)))
              ])))),
      background: backgroundRemove(context),
      confirmDismiss: (direction) async {
        return await ConfirmBottomSheet(
            message: "¿Estás seguro de proceder con la eliminación?",
            callbackOk: () {
              PlaylistUtils.removeTrackById(track.id).then((value) =>
                  Provider.of<PlaylistProvider>(context, listen: false)
                      .updatePlaylistSubscribers());
            }).showDialog(context);
      },
    );
  }

  Widget backgroundRemove(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      color: Theme.of(context).colorScheme.error,
      padding: EdgeInsets.symmetric(horizontal: Dimens.normalPadding),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text("Delete permanently",
            style: TextStyles.normalWhiteTextStyle),
        Icon(Icons.delete_forever_rounded, color: Colors.white)
      ]),
    );
  }

  Widget button(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, player, child) {
      return generateButton(player);
    });
  }

  Widget generateButton(PlayerProvider playerProvider) {
    String icon = playerProvider.matchTrack(track)
        ? playerProvider.getPlayerStatus() != PlayerState.playing
            ? "play"
            : "pause"
        : "play";
    return MainButton(() {
      SettingsUtils.updateCurrentPlayList(playlistId).then((value) {
        PlaylistUtils.getPlaylistById(playlistId).then((playlist) {
          AppState.playlist = playlist;

        });

        if (playerProvider.getCurrentTrack()?.id != track.id) {
          playerProvider.playTrack(track);
          return;
        }
        if (playerProvider.getPlayerStatus() == PlayerState.playing) {
          playerProvider.pauseTrack();
        } else {
          playerProvider.playTrack(track);
        }
      });
    }, size: Dimens.normalIcon * 1.3, icon: "assets/icons/$icon.svg");
  }
}
