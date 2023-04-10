

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService{
  static String? get bannerAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-7027299532858015/2193794122';
    }else if (Platform.isIOS){
      return 'ca-app-pub-7027299532858015/2193794122';
    }
    return null;
  }

  static String? get bannerAdUnitId2 {
    if(Platform.isAndroid){
      return 'ca-app-pub-7027299532858015/9513132515';
    }else if (Platform.isIOS){
      return 'ca-app-pub-7027299532858015/2193794122';
    }
    return null;
  }


  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded'),
    onAdFailedToLoad: (ad,error) {
      ad.dispose();
      print("error to load ad: ${error}");
    }
  );



  static String? get interstitialAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-7027299532858015/5412652706';
    }else if (Platform.isIOS){
      return 'ca-app-pub-7027299532858015/5412652706';
    }
    return null;
  }

  static String? get reardedAdUnitId {
    if(Platform.isAndroid){
      return 'ca-app-pub-7027299532858015/6859759457';
    }else if (Platform.isIOS){
      return 'ca-app-pub-7027299532858015/6859759457';
    }
    return null;
  }


}