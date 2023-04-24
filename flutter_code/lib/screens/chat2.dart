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
  late String dream;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();

  void initState() {

    mybanner.load();
    _createRewardedAd();
    createTutorial();
    if (!voiceHandler.isEnabled) {
      voiceHandler.initSpeech();
    }
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

  }

  final BannerAd mybanner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest());


  void _createRewardedAd(){
    RewardedAd.load(adUnitId: AdMobService.reardedAdUnitId!, request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) => setState(() {
          _rewardedAd = ad;
        }), onAdFailedToLoad: (error) => setState(() {
          _rewardedAd = null;
        })));
  }


  void showRewardedAd(){

    if (_rewardedAd != null){
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad,error){
          ad.dispose();
          _createRewardedAd();
        }
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => setState(() {
          final answerProvider = Provider.of<AnswerProvider>(context, listen: false);
          answerProvider.addReward();
        })
      );
    }
    else{
      showAddErrorDialog();
    }
  }




  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;
    final answerProvider = Provider.of<AnswerProvider>(context);




    return new WillPopScope(
        onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.logout_rounded, color: Colors.white,),
                  onPressed: (){
                    _showLogoutDialod();
                  },
                ),
                Image.asset("assets/name_blue.png", width: size.width *0.5,),
                GestureDetector(
                  onTap: (){
                    showTutorial();
                  },
                  child: Row(
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
                  ),
                )
              ],),
            automaticallyImplyLeading: false,
            backgroundColor: pale_colors.blue,
            elevation: 0,
          ),
          body: SingleChildScrollView(
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
                    "Describe your most recent dream and choose the way in which you want it to be interpreted and finished:",
                    style: TextStyle(
                      color: colors.brown,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                child: multiselection(size),
              ),
              Container(
                  child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: size.height * 0.25,
                      child: Center(child: Image.asset("assets/dreamer.png"))),
                  Container(
                    width: size.width * 0.8,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: textEditingController,
                      onChanged: (value) => setState(() => dream = value),
                      cursorColor: pale_colors.blue,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: pale_colors.blue, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: pale_colors.blue, width: 5),
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
                height: 50,
              )
            ],
          ),
        ),
      ),
          ),
        floatingActionButton:  showFab? FloatingActionButton(
          onPressed: () {
            sendVoice();
          },
          child: Icon(isListening ? Icons.mic_off : Icons.mic),
          backgroundColor: pale_colors.dark_pink,
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar( //bottom navigation bar on scaffold
          color:colors.brown,
          shape: CircularNotchedRectangle(), //shape of notch
          notchMargin: 5, //notche margin between floating button and bottom appbar
          child: Row( //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(key: keyButton, icon: Icon(FontAwesomeIcons.rectangleAd, color: Colors.white,), onPressed: () {
                showRewardedAd();

              },),
              IconButton(icon: Icon(Icons.send, color: Colors.white,), onPressed: () {
                if(answerProvider.rewardScore > 0){
                  answerProvider.callGPT(textEditingController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnswerPage()),
                  );
                }
                else{
                  _showMaterialDialog();
                }

              },),

            ],
          ),
        ),
          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  void _showLogoutDialod() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text('CAUTION!', style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/logout.png", width: 200,),
                Text('Are you sure you want to log out?',style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
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
                child: Text('Accept', style: TextStyle(color: colors.brown, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text('WARNING', style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/warning.png", width: 200,),
                Text('Your dont have any dream points left, you can get them by watching ads.',style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Accept', style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget multiselection(Size size) {
    return Container(
      width: size.width * 0.9,
      child: Center(
        child: MultiSelectContainer(
            maxSelectableCount: 2,
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
                value: 'Funny',
                label: 'Funny',
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
                value: 'Romantic',
                label: 'Romantic',
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
                value: 'Romantic',
                label: 'Romantic',
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
                value: 'Love',
                label: 'Love',
                decorations: MultiSelectItemDecorations(
                  decoration: BoxDecoration(
                      color: magic_colors.dark_pink.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20)),
                  selectedDecoration: BoxDecoration(
                      color: magic_colors.dark_pink,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              MultiSelectCard(
                value: 'Tarantino',
                label: 'Tarantino',
                decorations: MultiSelectItemDecorations(
                  decoration: BoxDecoration(
                      color: pale_colors.light_blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20)),
                  selectedDecoration: BoxDecoration(
                      color: pale_colors.light_blue,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              MultiSelectCard(
                value: 'Action',
                label: 'Action',
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
                value: 'Sad',
                label: 'Sad',
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
                value: 'Serious',
                label: 'Serious',
                decorations: MultiSelectItemDecorations(
                  decoration: BoxDecoration(
                      color: pale_colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20)),
                  selectedDecoration: BoxDecoration(
                      color: pale_colors.green,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],

            onMaximumSelected: (allSelectedItems, selectedItem) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: magic_colors.dark_pink,
                  content: Text('You can only select 2 options at a time')));
            },
            onChange: (allSelectedItems, selectedItem) {}),
      ),
    );
  }

  Widget buildMessageInput(AnswerProvider answerProvider) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                cursorColor: colors.brown,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: "Type your dream",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: textEditingController,
                onChanged: (value) => setState(() => dream = value),
                onSubmitted: (value) {
                  //onSendMessage(textEditingController.text, MessageType.text);
                },
              )),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //   ),
              //   child: IconButton(
              //     onPressed: () {
              //       //onSendMessage(textEditingController.text, MessageType.text);
              //     },
              //     icon: const Icon(Icons.keyboard_voice_rounded),
              //     color: magic_colors.dark_pink,
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {

                    answerProvider.explanationGPT(textEditingController.text);
                    answerProvider.storyGPT(textEditingController.text);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AnswerPage()));
                  },
                  icon: const Icon(Icons.send_rounded),
                  color: colors.brown,
                ),
              ),
            ],
          ),
        ));
  }


  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      pulseEnable: false,
      targets: _createTargets(),
      colorShadow: pale_colors.blue,
      textSkip: "SKIP",
      textStyleSkip : TextStyle(color: colors.brown, fontWeight: FontWeight.bold),
      paddingFocus: 0,
      opacityShadow: 1,
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
        enableOverlayTab : true,
        identify: "keyBottomNavigation1",
        keyTarget: keyButton,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
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
                    Center(child: Text(
                      "Watch ADs to get rewards that can be used for more dreams.",
                      style: TextStyle(
                        color: colors.brown,
                        fontSize: 25,
                      ),
                        textAlign: TextAlign.center,
                    )),
                    Container(
                      child:IconButton(icon: Icon(FontAwesomeIcons.rectangleAd, color: colors.brown, size: 40,), onPressed: () {  },),
                    ),
                    Center(child: Text(
                      "Each time you watch an AD, you will get 1 dream.",
                      style: TextStyle(
                        color: colors.brown,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Container(
                      child: Image.asset("assets/icon.png", width: 100,),
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

  void showAddErrorDialog(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text('ERROR', style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/error.png", width: 200,),
                Text('Ad could not load, please try again in the following minutes.',style: TextStyle(color: colors.brown, fontSize: 20)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Accept', style: TextStyle(color: pale_colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }


  }
