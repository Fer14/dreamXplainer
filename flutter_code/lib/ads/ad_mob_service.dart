import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'yourAdsToken';
    } else if (Platform.isIOS) {
      return 'yourAdsToken';
    }
    return null;
  }

  static String? get bannerAdUnitId2 {
    if (Platform.isAndroid) {
      return 'yourAdsToken';
    } else if (Platform.isIOS) {
      return 'yourAdsToken';
    }
    return null;
  }

  static final BannerAdListener bannerListener = BannerAdListener(
      onAdLoaded: (ad) => print('Ad loaded'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        print("error to load ad: ${error}");
      });

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'yourAdsToken';
    } else if (Platform.isIOS) {
      return 'yourAdsToken';
    }
    return null;
  }

  static String? get reardedAdUnitId {
    if (Platform.isAndroid) {
      return 'yourAdsToken';
    } else if (Platform.isIOS) {
      return 'yourAdsToken';
    }
    return null;
  }
}
