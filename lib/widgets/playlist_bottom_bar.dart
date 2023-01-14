import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/widgets/main_button.dart';
import 'package:provider/provider.dart';

class PlaylistBottomBar extends StatelessWidget {
  PlaylistBottomBar({Key? key}) : super(key: key);
  PlayerProvider? _playerProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      gradientBottomBg(context),
      Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: Dimens.normalPadding),
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.mainButtonSize,
                  vertical: Dimens.normalPadding),
              width: double.maxFinite,
              height: Dimens.heightBottomBar,
              decoration:
                  BoxDecoration(gradient: Gradients.playListGradient(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: trackNameLabel(context)),
                  const SizedBox(height: 5),
                  Expanded(flex: 1, child: playlistNameLabel(context))
                ],
              ))),
      sliderTrack(context),
      Positioned(
          bottom: Dimens.heightAppBar * 0.75,
          right: MediaQuery.of(context).size.width * 0.05,
          child: MainButton(() {
            playNextTrack(context);
          },
              size: Dimens.mainButtonSize * 1.15,
              icon: "assets/icons/next.svg")),
      Positioned(
          bottom: Dimens.heightAppBar * 0.75,
          right: (MediaQuery.of(context).size.width * 0.05) +
              Dimens.mainButtonSize,
          child: mainButton(context))
    ]);
  }

  void playNextTrack(BuildContext context) async {
    initializePlayerProvider(context);
    Track? nextTrack = await PlaylistUtils.getNextTrackPlaylist();
    if (nextTrack != null) {
      _playerProvider!.playTrack(nextTrack);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("¡Track not found!"),
      ));
    }
  }

  Widget mainButton(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, player, child) {
      String icon =
          player.getPlayerStatus() != PlayerState.playing ? "play" : "pause";
      return MainButton(() {
        initializePlayerProvider(context);
        switch (_playerProvider!.getPlayerStatus()) {
          case PlayerState.playing:
            {
              _playerProvider!.pauseTrack();
              break;
            }
          case PlayerState.paused:
            {
              _playerProvider!.playTrack(player.getCurrentTrack()!);
              break;
            }
          default:
            {
              _playerProvider!.resumeTrack();
            }
        }
      }, size: Dimens.mainButtonSize * 1.45, icon: "assets/icons/$icon.svg");
    });
  }

  Widget trackNameLabel(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, player, child) {
      String trackName = player.getCurrentTrack()?.name ?? "";
      return FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                    trackName.length > 30
                        ? trackName.substring(0, 30) + "..."
                        : trackName,
                    style: TextStyles.normalWhiteTextStyle)));
    });
  }

  Widget playlistNameLabel(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, player, child) {
      return FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/playlist.svg",
                  color: Colors.white, height: Dimens.smallIcon),
              SizedBox(width: Dimens.smallPadding),
              Text(AppState.playlist?.name ?? "",
                  style: TextStyles.normalWhiteTextStyle)
            ],
          ));
    });
  }

  Widget sliderTrack(BuildContext context) {
    var colorSchemes = Theme.of(context).colorScheme;

    return Positioned(
        left: 0,
        bottom: Dimens.heightBottomBar - (Dimens.normalPadding * 2) - 5,
        child: SizedBox(
            width: (MediaQuery.of(context).size.width * 1) -
                (Dimens.mainButtonSize * 2.45) +
                Dimens.smallPadding,
            child: StreamBuilder<Duration>(
                stream: AppState.player.onPositionChanged,
                builder: (context, snapshot) {
                  double max =
                      ((AppState.track?.duration ?? 1) / 1000).toDouble();
                  double value = (snapshot.data?.inSeconds ?? 0).toDouble();
                  return Slider(
                    value: value > max ? max : value,
                    max: max,
                    activeColor: Colors.white,
                    inactiveColor: colorSchemes.secondary,
                    onChanged: (double value) {
                      initializePlayerProvider(context);
                      _playerProvider!
                          .setPosition(Duration(seconds: value.toInt()));
                    },
                  );
                })));
  }

  Widget gradientBottomBg(BuildContext context) {
    return Container(
      height: Dimens.heightBottomBar * 1.75,
      width: double.maxFinite,
      decoration: BoxDecoration(gradient: Gradients.bottomBarBg(context)),
    );
  }

  void initializePlayerProvider(BuildContext context) {
    _playerProvider =
        _playerProvider ?? Provider.of<PlayerProvider>(context, listen: false);
  }
}
