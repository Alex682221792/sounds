// @dart=2.9

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music_player/app/ad_helper.dart';
import 'package:music_player/app/routes.dart';
import 'package:music_player/resources/styles/custom_theme.dart';
import 'package:music_player/utils/interstitial_ads_utils.dart';
import 'package:music_player/utils/player_utils.dart';
import 'package:music_player/view/check_point.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  PlayerUtils.initPlayerListeners();
  InterstitialAdsUtils().createInterstitialAd(AdHelper.interstitialAdUnitId);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sounds - Music Player',
      theme: CustomTheme(context).light(),
      darkTheme: CustomTheme(context).dark(),
      themeMode: ThemeMode.system,
      home: Container(
        height: 200,
        child: CheckPoint(),
      ),
      routes: Routes.paths,
    );
  }
}
