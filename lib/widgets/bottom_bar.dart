import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/track.dart';
import 'package:music_player/providers/menu_provider.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/resources/styles/button_styles.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/utils/settings_utils.dart';
import 'package:music_player/widgets/main_button.dart';
import 'package:music_player/widgets/player_bar_clipper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BottomBar extends StatelessWidget {
  BottomBar({Key? key}) : super(key: key);
  MenuProvider? menuProvider;
  PlayerProvider? _playerProvider;

  @override
  Widget build(BuildContext context) {
    postBuild(context);
    return Stack(alignment: Alignment.bottomCenter, children: [
      gradientBottomBg(context),
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(Dimens.normalPadding),
        child: ClipPath(
          clipper: PlayerBarClipper(
            Dimens.normalRadius * 2,
          ),
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
              )),
        ),
      ),
      getSwitchButton(context),
      sliderTrack(context),
      Positioned(
          bottom: Dimens.heightAppBar,
          right: MediaQuery.of(context).size.width * 0.1,
          child: MainButton(() {
            playNextTrack(context);
          },
              size: Dimens.mainButtonSize * 1.15,
              icon: "assets/icons/next.svg")),
      Positioned(
          bottom: Dimens.heightAppBar,
          right:
              (MediaQuery.of(context).size.width * 0.1) + Dimens.mainButtonSize,
          child: mainButton(context))
    ]);
  }

  void postBuild(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePlayerProvider(context);
    });
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
        left: (Dimens.mainButtonSize * 0.5) +
            (MediaQuery.of(context).size.width * 0.1),
        bottom: Dimens.heightBottomBar - Dimens.normalPadding - 5,
        child: Container(
            width: (MediaQuery.of(context).size.width * 0.8) -
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

  Widget getSwitchButton(BuildContext context) {
    final key = GlobalKey();
    var switchButton = Positioned(
        key: key,
        bottom: (Dimens.heightBottomBar - (Dimens.mainButtonSize * 0.625)) +
            Dimens.smallPadding,
        left:
            (MediaQuery.of(context).size.width * 0.1) - (Dimens.normalPadding),
        child: Consumer<MenuProvider>(builder: (context, menu, child) {
          return MainButton(() {
            initializeMenuProvider(context);
            menuProvider?.updateView(
                menu.isCurrentView(MenuProvider.SUMMARY_VIEW)
                    ? MenuProvider.PLAYLIST_VIEW
                    : MenuProvider.SUMMARY_VIEW);
          },
              size: Dimens.mainButtonSize * 1.25,
              icon: menu.isCurrentView(MenuProvider.SUMMARY_VIEW)
                  ? "assets/icons/playlist_gallery.svg"
                  : "assets/icons/home.svg");
        }));
    List<TargetFocus> targets = [];
    targets.add(getSwitchButtonTargetFocus(key));
    performTutorialCoach(targets, context);
    return switchButton;
  }

  TargetFocus getSwitchButtonTargetFocus(GlobalKey key) {
    return TargetFocus(identify: "Target 1", keyTarget: key, contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Browser",
                  style: TextStyles.secondaryStrongTextStyle(context),
                ),
                SizedBox(height: Dimens.normalPadding),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/playlist_gallery.svg",
                        color: Colors.white, height: Dimens.smallIcon),
                    SizedBox(width: Dimens.normalPadding),
                    Expanded(
                        child: Text(
                      "Manage your playlists from the gallery",
                      style: TextStyles.normalTextStyle,
                    ))
                  ],
                ),
                SizedBox(height: Dimens.normalPadding),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/home.svg",
                        color: Colors.white, height: Dimens.smallIcon),
                    SizedBox(width: Dimens.normalPadding),
                    Expanded(
                        child: Text(
                      "Access all your tracks, latest\nplaylists and more from the home page.",
                      style: TextStyles.normalTextStyle,
                    ))
                  ],
                )
              ],
            ),
          );
        },
      ),
    ]);
  }

  void performTutorialCoach(List<TargetFocus> targets, BuildContext context) {
    SettingsUtils.readSettings().then((settings) async {
      if (!settings.flagExplorer || !AppState.flagCoachTutorial) {
        return;
      }
      AppState.flagCoachTutorial = false;
      Timer(const Duration(seconds: 1), () {
        TutorialCoachMark(
          targets: targets,
          colorShadow: Theme.of(context).colorScheme.primary,
          onClickTarget: (target) {},
          onClickTargetWithTapPosition: (target, tapDetails) {},
          onClickOverlay: (target) {},
          onSkip: () {
            SettingsUtils.updateTutorialFlag(false);
          },
          onFinish: () {
            checkBatteryOptimization(context);
            SettingsUtils.updateTutorialFlag(false);
          },
        ).show(context: context);
      });
    });
  }

  void checkBatteryOptimization(BuildContext context) {
    Permission.ignoreBatteryOptimizations.isGranted.then((value) {
      if (!value) {
        showDialog(context);
      }
    });
  }

  void showDialog(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        elevation: 3,
        isScrollControlled: true,
        barrierColor: Colors.white12,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return backgroundServicesAdvisor(context);
        });
  }

  Widget backgroundServicesAdvisor(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 280,
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(
                child: Icon(Icons.battery_alert_outlined,
                    size: Dimens.normalIcon,
                    color: Theme.of(context).colorScheme.secondary)),
            Container(
                height: Dimens.heightBottomBar,
                child: Center(
                  child: Text("Notice",
                      style: TextStyles.titleAdviceTextStyle(context)),
                )),
            Container(
                margin: EdgeInsets.all(Dimens.largePadding),
                height: Dimens.heightBottomBar,
                child: Text(
                    "Turn off battery optimization to keep playing your tracks in the background..",
                    style: TextStyles.normalTextStyle)),
            Container(
                height: Dimens.heightBottomBar * 1.5,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () => {
                            Permission.ignoreBatteryOptimizations
                                .request()
                                .then((value) => Navigator.pop(context))
                          },
                      style: ButtonStyles.accentTextButton(context),
                      child: Text("Set up")),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"))
                ]))
          ],
        ));
  }

  void initializeMenuProvider(BuildContext context) {
    menuProvider =
        menuProvider ?? Provider.of<MenuProvider>(context, listen: false);
  }

  void initializePlayerProvider(BuildContext context) {
    _playerProvider =
        _playerProvider ?? Provider.of<PlayerProvider>(context, listen: false);
  }
}
