import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/app/constant_app.dart';
import 'package:music_player/resources/styles/gradients.dart';
import 'package:music_player/resources/styles/text_styles.dart';
import 'package:music_player/resources/values/dimens.dart';
import 'package:music_player/widgets/custom_nav_bar.dart';
import 'package:music_player/widgets/donut_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoApp extends StatefulWidget {
  const InfoApp({Key? key}) : super(key: key);

  @override
  State<InfoApp> createState() => _InfoAppState();
}

class _InfoAppState extends State<InfoApp> with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomNavBar.getBar("", () {
          Navigator.pop(context);
        }, context),
        extendBodyBehindAppBar: true,
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        gradient: Gradients.checkPointBg(context),
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(Dimens.normalRadius * 5),
                            bottomRight:
                                Radius.circular(Dimens.normalRadius * 5))),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Stack(
                      children: [
                        Center(
                            child: Hero(
                                tag: "logo_ico",
                                child: SvgPicture.asset(
                                    "assets/icons/sound.svg",
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                        AnimatedBuilder(
                          animation: _heartAnimationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: DonutPainter(
                                  _heartAnimation.value,
                                  (_heartAnimation.value * -0.1) + 10,
                                  Offset(
                                      MediaQuery.of(context).size.width * 0.5,
                                      MediaQuery.of(context).size.height *
                                          0.2)),
                            );
                          },
                        ),
                        Positioned(
                            bottom: -8,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: Text("SOUNDS",
                                        style: TextStyles.appNameTextStyle(
                                            context)))))
                      ],
                    )),
                description(context)
              ],
            )));
  }

  Widget description(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.largePadding),
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Version:", style: TextStyles.normalTextStyle),
            Text("1.0.0", style: TextStyles.normalTextStyle),
            SizedBox(height: Dimens.normalPadding),
            Text("Developed by:", style: TextStyles.normalTextStyle),
            Text("Encoding Ideas", style: TextStyles.normalTextStyle),
            SizedBox(height: Dimens.largePadding),
            Text("¡Thanks for downloading Sounds!",
                style: TextStyles.normalTextStyle),
            SizedBox(height: Dimens.largePadding),
            Divider(
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: Dimens.largePadding),
            Text("¿Do you want to support us?",
                style: TextStyles.normalTextStyle),
            SizedBox(height: Dimens.normalPadding),
            GestureDetector(
                onTap: openBuyCoffeeUrl,
                child: Image.asset("assets/images/buy_me_a_coffee.png",
                    height: 50))
          ],
        ));
  }

  void openBuyCoffeeUrl() {
    launchUrl(Uri.parse(ConstantApp.URL_BUY_ME_A_COFFEE),
        mode: LaunchMode.externalApplication);
  }
}
