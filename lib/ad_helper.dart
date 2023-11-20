// Dart imports:
import 'dart:io';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: avoid_classes_with_only_static_members
class AdHelper {
  //------------------------------
  // !本番環境ではtrueとすること
  //------------------------------
  static bool release = true;

  /*
   * バナー広告ユニットIDの取得
   */
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return release
          ? 'ca-app-pub-8046295810838892/4866161364'
          : 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return release
          ? 'ca-app-pub-8046295810838892/3365339445'
          : 'ca-app-pub-3940256099942544/2934735716';
    } else {
      // throw UnsupportedError('Unsupported platform');
      return 'pub-3940256099942544/2934735716';
    }
  }

  /*
   * バナー広告取得
   */
  static void initializationAd() {
    //--------------
    // Admob初期化
    //--------------
    MobileAds.instance.initialize();

    //----------------------
    // 子供向けの設定
    //----------------------
    final requestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  /*
   * バナー広告取得
   */
  static BannerAd getBannerAd() {
    //----------------------
    // バナー広告生成
    //----------------------
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => (),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        onAdClosed: (Ad ad) {
          ad.dispose();
        },
      ),
    );
  }
}
