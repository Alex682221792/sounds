import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music_player/app/app_state.dart' as local;

class InterstitialAdsUtils {
  static InterstitialAd? _interstitialAd;
  int numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 5;

  void createInterstitialAd(String adId) {
    InterstitialAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd(adId);
            }
          },
        ));
  }

  void showInterstitialAd(
      {required String adId,
      required Function onDismissed,
      required Function onShowed}) {
    if(local.AppState.tapsToShowBanner > local.AppState.counterTapsBanner){
      local.AppState.counterTapsBanner++;
      onDismissed.call();
      return;
    }
    local.AppState.counterTapsBanner = 0;
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => onShowed.call(),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        onDismissed.call();
        ad.dispose();
        createInterstitialAd(adId);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd(adId);
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
