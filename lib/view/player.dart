import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/app_state.dart';
import 'package:music_player/models/playlist.dart';
import 'package:music_player/providers/player_provider.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/utils/playlist_utils.dart';
import 'package:music_player/view/playlist_view.dart';
import 'package:music_player/widgets/main_button.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlayerState();
  }
}

class PlayerState extends State<Player> {
  StreamSubscription<Duration>? onPositionChange;
  double _circleSize = 200.0;
  double _baseSize = 200.0;
  List<double> _sampleData = [];
  int lastSecondPlayed = 0;

  @override
  void initState() {
    super.initState();
    List<double> mp3Samples = File(AppState.track!.path)
        .readAsBytesSync()
        .map((e) => e.toDouble())
        .toList();
    List<double> data = [];
    while (mp3Samples.length > (AppState.track!.duration / 1000)) {
      data.clear();
      data = mp3Samples.map((e) => e).toList();
      mp3Samples.clear();
      for (var i = 0; i < data.length; i++) {
        if (i % 2 == 0) {
          mp3Samples.add(data[i]);
        }
      }
    }
    _sampleData = mp3Samples;
    data.clear();
  }

  @override
  Widget build(BuildContext context) {
    double controlsOffset = Dimens.largeIcon * 0.5;
    //(MediaQuery.of(context).size.width * (4 / 14)) * 0.5;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerProvider>(
              create: (_) => PlayerProvider())
        ],
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: customAppBar(),
            body: Stack(
              children: [
                //GradientBg(),
                overlayBg(context),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Expanded(
                        child: Center(
                            child: StreamBuilder<Duration>(
                                initialData: const Duration(seconds: 0),
                                stream: AppState.player.onPositionChanged,
                                builder: (context, snapshot) {
                                  var index = snapshot.data!.inSeconds;
                                  lastSecondPlayed = index;
                                  index =
                                      index >= _sampleData.length ? 0 : index;
                                  _circleSize = _baseSize + _sampleData[index];
                                  return AnimatedContainer(
                                      width: _circleSize,
                                      height: _circleSize,
                                      curve: Curves.fastOutSlowIn,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ));
                                })))),
                Positioned(
                    bottom: 120 + controlsOffset - Dimens.smallIcon * 0.5,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: controlPanel())),
                Positioned(
                    bottom: 120,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: MainButton(() {},
                            size: Dimens.largeIcon,
                            icon: "assets/icons/play.svg"))),

                Positioned(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: FutureBuilder<Playlist>(
                          future: PlaylistUtils.getCurrentPlaylist(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return PlaylistView(playlist: snapshot.data!);
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        )))
              ],
            )));
  }

  /*Widget audioWaves(BuildContext context) {
    return RectangleWaveform(
        samples: _sampleData,
        height: 100,
        width: MediaQuery.of(context).size.width);
  }*/

  PreferredSize customAppBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(Dimens.heightAppBar),
        // here the desired height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Container(
              padding: EdgeInsets.all(Dimens.normalPadding),
              width: Dimens.smallIcon,
              height: Dimens.smallIcon,
              child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/back.svg"))),
        ));
  }

  Widget overlayBg(BuildContext context) {
    double blur = Dimens.blurValue;
    return Positioned.fill(
      child: ClipRRect(
        // Clip it cleanly.
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
              color: Theme.of(context)
                  .colorScheme
                  .tertiary
                  .withAlpha(Dimens.alphaOverlay)),
        ),
      ),
    );
  }

  Widget mainPlayButton(BuildContext context) {
    double size = MediaQuery.of(context).size.width * (4 / 14);
    return Stack(children: [
      Container(width: 0, height: size),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: Gradients.playListGradient(context))))),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                  width: size - 3,
                  height: size - 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  )))),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/play.svg",
                      color: Colors.white, height: Dimens.largeIcon * 0.75))))
    ]);
  }

  Widget controlPanel() {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xff870160),
              Color(0xfff39060),
              Color(0xffca485c),
              Color(0xffe16b5c),
              Color(0xfff39060),
              Color(0xffffb56b),
            ],
            // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        child: Row(children: [
          Expanded(child: SizedBox(), flex: 1),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/aleatory.svg",
                      color: Colors.white, height: Dimens.smallIcon))),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/backward.svg",
                      color: Colors.white, height: Dimens.smallIcon))),
          Expanded(child: SizedBox(), flex: 4),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/forward.svg",
                      color: Colors.white, height: Dimens.smallIcon))),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/loop.svg",
                      color: Colors.white, height: Dimens.smallIcon))),
          Expanded(child: SizedBox(), flex: 1)
        ]));
  }
}
