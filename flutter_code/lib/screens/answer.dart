import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../ads/ad_mob_service.dart';
import '../services/app.localizations.dart';
import '../utils/appbar.dart';
import 'chat2.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage>
    with SingleTickerProviderStateMixin {

  InterstitialAd? _interstitialAd;
  late TabController _tabController;
  int _selectedIndex = 0;
  final _selectedColor = pale_colors.blue;

  final _tabs_en = const [
    Tab(text: 'Explanation'),
    Tab(text: 'Dream ending'),
  ];

  final _tabs_es = const [
    Tab(text: 'Explicación'),
    Tab(text: 'Final del sueño'),
  ];

  final BannerAd mybanner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId2!,
      listener: AdMobService.bannerListener,
      request: const AdRequest());

  @override
  void initState() {
    mybanner.load();
    _createInterstitialAd();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
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
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final answerProvider = Provider.of<AnswerProvider>(context);
    final appLocalization = AppLocalization.of(context);



    return new WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                backgroundColor: Colors.white,
                title: Text(appLocalization!.getTranslatedValue('wait').toString(), style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/new.png", width: 200,),
                    Text(appLocalization!.getTranslatedValue('go_back_warning').toString(),textAlign: TextAlign.justify,style: TextStyle(color: colors.brown, fontSize: 20)),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(appLocalization!.getTranslatedValue('cancel').toString(), style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {
                      showInsterstitialAd();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chat2Page()),

                      );
                    },
                    child: Text(appLocalization!.getTranslatedValue('accept').toString(), style: TextStyle(color:colors.brown, fontSize: 20, fontWeight: FontWeight.bold)),
                  )
                ],
              );
            });
        return false;
      },
      child: Scaffold(
          appBar:  AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(FontAwesomeIcons.cloud, color: Colors.white,), onPressed: () {
                  showDreamDialog(answerProvider, appLocalization);
                }
                  ,),
                Padding(padding: EdgeInsets.only(bottom: 10),
                  child:Image.asset("assets/name_blue.png", width: size.width *0.5,),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/icon.png", width: size.width *0.1,),
                    SizedBox(width: 5,),
                    AnimatedDigitWidget(
                      autoSize: false,
                      value: answerProvider.rewardScore,
                      textStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )
              ],),
            automaticallyImplyLeading: false,
            backgroundColor: pale_colors.blue,
            elevation: 0,
          ),
          body: SingleChildScrollView(
              child: Container(
        height: size.height * 1,
        color: pale_colors.pink,
        child: Column(
          children: <Widget>[
            Container(
              height: kToolbarHeight + 8.0,
              padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
              decoration: BoxDecoration(
                color: _selectedColor,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100)),
                    color: Colors.white),
                labelColor: colors.brown,
                unselectedLabelColor: Colors.white,
                tabs: (Localizations.localeOf(context).toString() == "es") ? _tabs_es : _tabs_en,
              ),
            ),
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
                  padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.55,
                    decoration: BoxDecoration(),
                    child: TabBarView(controller: _tabController, children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.125,
                            child: answerProvider.explanationError ?
                            Image.asset(
                              'assets/server_down.png',
                            ): Image.asset(
                              'assets/explanation.png',
                            ),
                          ),
                          (answerProvider.explanationAnswer != null)
                              ? Container(
                                  height: size.height * 0.275,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          answerProvider.explanationAnswer!,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: colors.brown,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              : answerProvider.explanationError ?
                          Container(
                            height: size.height * 0.275,
                            child: Column(
                              children: [
                                Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        appLocalization!.getTranslatedValue('connection_error').toString(),
                                        style: TextStyle(
                                          color: colors.brown,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ): Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: LoadingAnimationWidget.stretchedDots(
                                    color: pale_colors.blue,
                                    size: 200,
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.125,
                            child: answerProvider.storyError ?
                            Image.asset(
                              'assets/server_down.png',
                            ): Image.asset(
                              'assets/dream2.png',
                            ),
                          ),
                          (answerProvider.storyAnswer != null)
                              ? Container(
                                  height: size.height * 0.275,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          answerProvider.storyAnswer!,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: colors.brown,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              : answerProvider.storyError ?
                              Container(
                                height: size.height * 0.275,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        appLocalization!.getTranslatedValue('internet_error_data').toString(),
                                        style: TextStyle(
                                          color: colors.brown,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ):
                              Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: LoadingAnimationWidget.stretchedDots(
                                    color: pale_colors.blue,
                                    size: 200,
                                  ),
                                ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ),
            Container(
              height: size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  (_selectedIndex == 0) ?
                  (answerProvider.explanationAnswer != null)
                      ?   copyButton( size,  answerProvider, answerProvider.explanationAnswer, ) : Container() :
                  (answerProvider.storyAnswer != null) ? copyButton( size,  answerProvider, answerProvider.storyAnswer) : Container() ,
                  (_selectedIndex == 0) ?
                  (answerProvider.explanationAnswer != null)
                      ?   calendarButton( size,  answerProvider.explanationAnswer, appLocalization) : Container() :
                  (answerProvider.storyAnswer != null) ? calendarButton( size,   answerProvider.storyAnswer, appLocalization) : Container() ,
                  (_selectedIndex == 0) ?
                  (answerProvider.explanationAnswer != null)
                      ?   shareButton( size,  answerProvider, answerProvider.explanationAnswer) : Container() :
                  (answerProvider.storyAnswer != null) ? shareButton( size,  answerProvider, answerProvider.storyAnswer) : Container() ,
                ],
              ),
            ),
            Center(
              child: Container(
                height: mybanner.size.height.toDouble(),
                width: mybanner.size.width.toDouble(),
                child: AdWidget(ad: mybanner),
              ),
            )
          ],
        ),
      )),

          ),
    );
  }

  void showDreamDialog(answerProvider,appLocalization){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text(appLocalization!.getTranslatedValue('re_read_dream').toString(), style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: SingleChildScrollView(
              child: Text(answerProvider.dreamanswer,textAlign: TextAlign.justify,style: TextStyle(color: colors.brown, fontSize: 20)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(appLocalization!.getTranslatedValue('accept').toString(), style: TextStyle(color:pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }



  Widget calendarButton(Size size, dream,appLocalization) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize:
              Size(size.height * 0.1, size.height * 0.1),
          backgroundColor: pale_colors.yellow,
          shape: CircleBorder()),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                backgroundColor: Colors.white,
                title: Text(appLocalization!.getTranslatedValue('coming_soon').toString(), style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/calendar_blue.png", width: 200,),
                    Text(appLocalization!.getTranslatedValue('feature_soon').toString(),style: TextStyle(color: colors.brown, fontSize: 20)),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(appLocalization!.getTranslatedValue('accept').toString(), style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                  )
                ],
              );
            });
      },
      child: Icon(
        FontAwesomeIcons.calendarPlus,
        color: colors.brown,
        size: 35,
      ),
    );
  }

  Widget copyButton(Size size, AnswerProvider answerProvider, text){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize:
          Size(size.height * 0.1, size.height * 0.1),
          backgroundColor: pale_colors.blue,
          shape: CircleBorder()),
      onPressed: () async {
        await Clipboard.setData(ClipboardData(
            text: text!));
      },
      child: Icon(
        Icons.content_copy,
        color: Colors.white,
        size: 35,
      ),
    );
  }

  Widget shareButton(Size size, AnswerProvider answerProvider, text){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize:
          Size(size.height * 0.1, size.height * 0.1),
          backgroundColor: pale_colors.blue,
          shape: CircleBorder()),
      onPressed: () async {
        Share.share(
            text.toString());
      },
      child: Icon(
        FontAwesomeIcons.share,
        color: Colors.white,
        size: 35,
      ),
    );
  }




}
