import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hello_world/ads/ad_mob_service.dart';
import 'package:hello_world/screens/answer.dart';
import 'package:hello_world/services/voice_handler.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../provider/answer_provider.dart';
import '../services/app.localizations.dart';
import '../utils/appbar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/global_vars.dart';
import 'login.dart';

class Chat2Page extends StatefulWidget {
  const Chat2Page({super.key});

  @override
  State<Chat2Page> createState() => _Chat2PageState();
}

class _Chat2PageState extends State<Chat2Page> {
  TextEditingController textEditingController = TextEditingController();
  final VoiceHandler voiceHandler = VoiceHandler();
  bool isListening = false;
  late String dream = "";
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();
  String tag_selected = "";

  @override
  void initState() {
    mybanner.load();
    super.initState();
    if (!voiceHandler.isEnabled) {
      voiceHandler.initSpeech();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _createRewardedAd();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createTutorial();
    });



  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final BannerAd mybanner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest());

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdMobService.reardedAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => setState(() {
                  _rewardedAd = ad;
                }),
            onAdFailedToLoad: (error) => setState(() {
                  _rewardedAd = null;
                })));
  }

  void showRewardedAd(appLocalization) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardedAd();
      });
      _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) => setState(() {
                final answerProvider =
                    Provider.of<AnswerProvider>(context, listen: false);
                answerProvider.addReward();
              }));
    } else {
      showAddErrorDialog(appLocalization);
    }
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    final answerProvider = Provider.of<AnswerProvider>(context);
    final appLocalization = AppLocalization.of(context);


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  _showLogoutDialod(appLocalization!);
                },
              ),
              Image.asset(
                "assets/name_blue.png",
                width: size.width * 0.5,
              ),
              GestureDetector(
                onTap: () {
                  showTutorial();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/icon.png",
                      width: size.width * 0.1,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    AnimatedDigitWidget(
                      autoSize: false,
                      value: answerProvider.rewardScore,
                      textStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: pale_colors.blue,
          elevation: 0,
        ),
        body: Stack(

          children: [
            SingleChildScrollView(
              child: Container(
                height: size.height * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: mybanner.size.height.toDouble(),
                        width: mybanner.size.width.toDouble(),
                        child: AdWidget(ad: mybanner),
                      ),
                      Container(
                        width: size.width * 0.8,
                        child: Center(
                          child: Text(
                            appLocalization!.getTranslatedValue('main_instruction').toString(),
                            style: TextStyle(
                              color: colors.brown,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        child: multiselection(size,appLocalization),
                      ),
                      Container(
                          child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              height: size.height * 0.25,
                              child: Center(
                                  child: Image.asset("assets/dreamer.png"))),
                          Container(
                            margin: EdgeInsets.only(bottom: size.height * 0.05),
                            width: size.width * 0.8,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: textEditingController,
                              onChanged: (value) =>
                                  setState(() => dream = value),
                              cursorColor: pale_colors.blue,
                              decoration: InputDecoration(
                                hintText: appLocalization!.getTranslatedValue('hint_dream').toString(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: pale_colors.blue, width: 2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: pale_colors.blue, width: 5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                )),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 12,
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            !showFab ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.05,
                color: pale_colors.blue,
                  child:  bottomButtons(answerProvider, appLocalization),),
            ) : Container(),
          ],
        ),
        floatingActionButton: showFab
            ? FloatingActionButton(
                onPressed: () {
                  sendVoice();
                },
                child: Icon(isListening ? Icons.mic_off : Icons.mic),
                backgroundColor: pale_colors.dark_pink,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: showFab ?  BottomAppBar(
          // do not hide bottom appbar when keyboard is shown
          color: pale_colors.blue,
          shape: CircularNotchedRectangle(), //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: bottomButtons(answerProvider,appLocalization),
        ) : null,
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget bottomButtons(answerProvider, appLocalization){
    return Row(
      //children inside bottom appbar
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          key: keyButton,
          icon: Icon(
            FontAwesomeIcons.rectangleAd,
            color: Colors.white,
          ),
          onPressed: () {
            showRewardedAd(appLocalization);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () {
            if (answerProvider.rewardScore > 0) {
              if (textEditingController.text != "") {
                if (tag_selected != "") {
                  Locale myLocale = Localizations.localeOf(context);
                  answerProvider.callGPT(
                      textEditingController.text, tag_selected!, myLocale!);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AnswerPage()),
                  );
                } else {
                  _showMaterialDialog(
                      "assets/tag2.png", appLocalization!.getTranslatedValue('error_tag').toString(), appLocalization);
                }
              } else {
                _showMaterialDialog("assets/empty.png",
                    appLocalization!.getTranslatedValue('error_dream').toString(), appLocalization);
              }
            } else {
              _showMaterialDialog("assets/warning.png",
                  appLocalization!.getTranslatedValue('error_points').toString(), appLocalization);
            }
          },
        ),
      ],
    );

  }


  void _showLogoutDialod(appLocalization) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text(appLocalization!.getTranslatedValue('caution').toString(),
                style: TextStyle(
                    color: colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/logout.png",
                  width: 200,
                ),
                Text(appLocalization!.getTranslatedValue('confirm_logout').toString(),
                    style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalization!.getTranslatedValue('cancel').toString(),
                    style: TextStyle(
                        color: pale_colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  GetStorage().write('keep', false);
                  GetStorage().write('email', null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PolicyPage()),
                  );
                },
                child: Text(appLocalization!.getTranslatedValue('accept').toString(),
                    style: TextStyle(
                        color: colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }

  void _showMaterialDialog(image, text, appLocalization) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text(appLocalization!.getTranslatedValue('warning').toString(),
                style: TextStyle(
                    color: colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  image,
                  width: 200,
                ),
                Text(text, style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalization!.getTranslatedValue('accept').toString(),
                    style: TextStyle(
                        color: pale_colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }

  void sendVoice() async {
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setState(() {
        isListening = false;
      });
    } else {
      setState(() {
        isListening = true;
      });
      final result = await voiceHandler.startListening();
      setState(() {
        isListening = false;
      });
      setState(() {
        dream = result;
        textEditingController.text = dream;
      });
    }
  }

  Widget multiselection(Size size, appLocalization) {
    return Container(
      width: size.width * 0.9,
      child: Center(
        child: MultiSelectContainer(
          onChange: (allSelectedItems, selectedItem) {
            setState(() {
              if (selectedItem != tag_selected){
                tag_selected = selectedItem;
              }
              else{
                tag_selected = "";
              }
            });
            print(tag_selected);
          },
          maxSelectableCount: 1,
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          items: [
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('funny_tag').toString(),
              label: appLocalization!.getTranslatedValue('funny_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.violet.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.violet,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('horror_tag').toString(),
              label: appLocalization!.getTranslatedValue('horror_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.pink,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('action_tag').toString(),
              label: appLocalization!.getTranslatedValue('action_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.blue,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('serious_tag').toString(),
              label: appLocalization!.getTranslatedValue('serious_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.green,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('romantic_tag').toString(),
              label: appLocalization!.getTranslatedValue('romantic_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.dark_pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.dark_pink,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('tarantino_tag').toString(),
              label: appLocalization!.getTranslatedValue('tarantino_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.red,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('sad_tag').toString(),
              label: appLocalization!.getTranslatedValue('sad_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.orange.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.orange,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            MultiSelectCard(
              value: appLocalization!.getTranslatedValue('fantasy_tag').toString(),
              label: appLocalization!.getTranslatedValue('fantasy_tag').toString(),
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.light_blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.light_blue,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
          onMaximumSelected: (allSelectedItems, selectedItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: magic_colors.dark_pink,
                content: Text(appLocalization!.getTranslatedValue('error_multiple_tags').toString())));
          },
        ),
      ),
    );
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      pulseEnable: false,
      targets: _createTargets(),
      colorShadow: pale_colors.blue,
      textSkip: AppLocalization.of(context).getTranslatedValue('skip').toString(),
      textStyleSkip:
          TextStyle(color: colors.brown, fontWeight: FontWeight.bold),
      paddingFocus: 0,
      opacityShadow: 0.9,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "keyBottomNavigation1",
        keyTarget: keyButton,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        radius: 100,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                height: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Text(
                          AppLocalization.of(context).getTranslatedValue('main_instruction').toString(),
                      style: TextStyle(
                        color: colors.brown,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.rectangleAd,
                          color: colors.brown,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Center(
                        child: Text(
                          AppLocalization.of(context).getTranslatedValue('ad_instruction_2').toString(),
                      style: TextStyle(
                        color: colors.brown,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Container(
                      child: Image.asset(
                        "assets/icon.png",
                        width: 100,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  void showAddErrorDialog(appLocalization) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text(appLocalization!.getTranslatedValue('error').toString(),
                style: TextStyle(
                    color: colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/error.png",
                  width: 200,
                ),
                Text(
                    appLocalization!.getTranslatedValue('ad_error').toString(),
                    style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalization!.getTranslatedValue('accept').toString(),
                    style: TextStyle(
                        color: pale_colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }
}
