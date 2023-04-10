import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat2.dart';
import 'package:hello_world/screens/mode.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../ads/ad_mob_service.dart';
import '../utils/appbar.dart';
import '../utils/policy_text.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  InterstitialAd? _interstitialAd;


  @override
  void initState(){
    _createInterstitialAd();

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _createInterstitialAd(){
    InterstitialAd.load(
        adUnitId : AdMobService.interstitialAdUnitId!,
        request : const AdRequest(),
        adLoadCallback : InterstitialAdLoadCallback(onAdLoaded: (ad)=> _interstitialAd = ad , onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null)
    );
  }

  void showInsterstitialAd(){
    if (_interstitialAd != null){
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _createInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad,error){
            ad.dispose();
            _createInterstitialAd();
          }
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final answerProvider = Provider.of<AnswerProvider>(context);

    return Scaffold(
        body: Container(
          margin: MediaQuery.of(context).padding,
      color: pale_colors.pink,
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.75,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(child: Center(child:Image.asset("assets/logo.png", width: size.width *0.8,) ,),),
                      Text('Hello from the dreamXplainer team!',
                          style: TextStyle(
                            color: colors.brown,
                            fontSize: 20,
                          )),
                      Text(policy_text,
                          style: TextStyle(
                            color: colors.brown,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().moveY(
                duration: 500.ms,
              ),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: ConfirmationSlider(
              foregroundColor: pale_colors.blue,
              textStyle: TextStyle(
                color: colors.brown,
                fontSize: 20,
              ),
              onConfirmation: () => {
                showInsterstitialAd(),
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chat2Page()),
                  )
              },
            ),
          )
        ],
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }


}
