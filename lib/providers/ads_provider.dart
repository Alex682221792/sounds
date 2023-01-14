import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider extends ChangeNotifier{
  bool isCustomerSumBannerAdReady = false;
  Map<String, BannerAd> bannerAds = {};

  void updateCustomerSumBannerStatus(bool isReady) {
    isCustomerSumBannerAdReady = isReady;
    notifyListeners();
  }

  void initBannerAd(String adId){
    if(bannerAds.containsKey(adId)){
      return;
    }
    var bannerAd = BannerAd(
        adUnitId: adId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            updateCustomerSumBannerStatus(true);
          },
          onAdFailedToLoad: (ad, err) {
            updateCustomerSumBannerStatus(false);
            ad.dispose();
          },
        )
    );
    bannerAds[adId] = bannerAd;
    bannerAd.load();
  }

  Widget getAdWidget(String adId){
    if(bannerAds.containsKey(adId)) {
      var bannerAd = bannerAds[adId]!;
      return SizedBox(
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        child: AdWidget(ad: bannerAd),
      );
    }
    return const Expanded(flex: 1, child: Text("Error al cargar adMob"));
  }
}