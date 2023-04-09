import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/ads/ad_mob_service.dart';
import 'package:hello_world/screens/answer.dart';
import 'package:hello_world/services/voice_handler.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import '../provider/adProvider.dart';
import '../provider/answer_provider.dart';
import '../utils/appbar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  int _rewardScore = 0;

  void initState() {
    _createInterstitialAd();
    mybanner.load();
    super.initState();
  }

  final BannerAd mybanner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest());

  void _createInterstitialAd(){
    InterstitialAd.load(
      adUnitId : AdMobService.interstitialAdUnitId!,
      request : const AdRequest(),
      adLoadCallback : InterstitialAdLoadCallback(onAdLoaded: (ad)=> _interstitialAd = ad , onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null)
    );
  }

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
          _rewardScore++;
        })
      );
    }
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
    final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;
    final answerProvider = Provider.of<AnswerProvider>(context);
    final adProvider = Provider.of<AdProvider>(context);

    return Scaffold(
        appBar: MainAppBar(),
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
                  "Write your dream and choose the way in chich you want it to be explained and finnished.",
                  style: TextStyle(
                    color: colors.brown,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: multiselection(),
            ),
            Container(
                child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: size.height * 0.25,
                    child: Center(child: Image.asset("assets/dream2.png"))),
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
                    maxLines: 14,
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
            IconButton(icon: Icon(FontAwesomeIcons.rectangleAd, color: Colors.white,), onPressed: () {},),
            IconButton(icon: Icon(Icons.send, color: Colors.white,), onPressed: () {
              answerProvider.explanationGPT(textEditingController.text);
              answerProvider.storyGPT(textEditingController.text);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnswerPage()),
              );
            },),

          ],
        ),
      ),
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void sendVoice() async {
    if (!voiceHandler.isEnabled) {
      voiceHandler.initSpeech();
    }
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

  Widget multiselection() {
    return Container(
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
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Detailed',
              label: 'Detailed',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.pink,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Random',
              label: 'Random',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.dark_pink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.dark_pink,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Love',
              label: 'Love',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.light_blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.light_blue,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            MultiSelectCard(
              value: 'Sad',
              label: 'Sad',
              decorations: MultiSelectItemDecorations(
                decoration: BoxDecoration(
                    color: pale_colors.yellow.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                selectedDecoration: BoxDecoration(
                    color: pale_colors.yellow,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ],
          onMaximumSelected: (allSelectedItems, selectedItem) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: magic_colors.dark_pink,
                content: Text('You can only select 2 options at a time')));
          },
          onChange: (allSelectedItems, selectedItem) {}),
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
}
