import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/routes.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/widgets/donut_painter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/incoming_call_service.dart';

class CheckPoint extends StatefulWidget {
  const CheckPoint({Key? key}) : super(key: key);

  @override
  State<CheckPoint> createState() => _CheckPointState();
}

class _CheckPointState extends State<CheckPoint> with TickerProviderStateMixin {
  late Animation _heartAnimation;
  late AnimationController _heartAnimationController;
  var reversing = false;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
        reverseDuration: const Duration(milliseconds: 600),
        vsync: this,
        duration: const Duration(milliseconds: 1200));
    _heartAnimation = Tween(begin: 70.0, end: 90.0).animate(CurvedAnimation(
        curve: Curves.bounceOut,
        parent: _heartAnimationController,
        reverseCurve: Curves.bounceOut));

    _heartAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _heartAnimationController.repeat(reverse: true);
      }
    });
    _heartAnimationController.repeat(reverse: true);
    checkPermissions();
  }

  void checkPermissions() {
    [Permission.storage, Permission.phone].request().then((statuses) {
      if (statuses[Permission.storage]!.isGranted &&
          statuses[Permission.phone]!.isGranted) {
        Timer(Duration(seconds: 1), () {
          IncomingCallService.initialize();
          Navigator.pushReplacementNamed(context, Routes.HOME);
        });
      }
    });
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            decoration:
                BoxDecoration(gradient: Gradients.checkPointBg(context)),
            child: Stack(
              children: [
                Center(
                    child: SvgPicture.asset("assets/icons/sound.svg",
                        color: Theme.of(context).colorScheme.primary)),
                AnimatedBuilder(
                  animation: _heartAnimationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: DonutPainter(
                          _heartAnimation.value,
                          (_heartAnimation.value * -0.1) + 10,
                          Offset(MediaQuery.of(context).size.width * 0.5,
                              MediaQuery.of(context).size.height * 0.5)),
                    );
                  },
                ),
                Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.2,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Verifying configurations...",
                            textAlign: TextAlign.center,
                            style: TextStyles.normalTextStyle)))
              ],
            )));
  }
}
