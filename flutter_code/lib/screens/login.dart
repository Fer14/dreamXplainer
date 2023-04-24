import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hello_world/provider/answer_provider.dart';
import 'package:hello_world/screens/chat2.dart';
import 'package:hello_world/screens/register.dart';
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
import '../utils/global_vars.dart';
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

  final userController = TextEditingController();//controllador para el textform del usuario
  final passController = TextEditingController();
  bool error = false;
  bool keep = false;

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
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
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
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
                  child: Container(
                    width: double.infinity,
                    height: size.height * 0.75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/better_logo.png", width: size.width *0.7,),
                        userTextField(size),
                        passwordTextField(size),
                        checkSession(size),
                        register_link(size),
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
                foregroundColor: !error ? pale_colors.blue : pale_colors.red,
                textStyle: TextStyle(
                  color: colors.brown,
                  fontSize: 20,
                ),
                text: !error ? "Slide to confirm" : "Data incorrect",
                onConfirmation: () => {
                  login(userController.text, passController.text, answerProvider)
                },
              ),
            )
          ],
      ),
    ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget checkSession(Size size){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.2, vertical: size.height * 0.01),
      color: Colors.white,
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            fillColor:
            MaterialStateProperty.all(pale_colors.blue),
            shape: const CircleBorder(),
            value: keep,
            onChanged: (value) {
              setState(() {
                keep = value!;
              });
            },
          ),
          Text(
            "Keep me logged in",
            style: TextStyle(
              color: colors.brown,
            ),
          ),
        ],
      ),
    );
  }

  Widget register_link(Size size) {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            width: size.width * 0.7,
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.13, vertical: size.height * 0.01),
            //padding: EdgeInsets.symmetric(horizontal: size.width * 0.13, vertical: size.height * 0.07),
            height: size.height * 0.09,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?  ",
                    style: TextStyle(
                      color: colors.brown,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      "Register.",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: pale_colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }



  Widget userTextField(Size size) {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.13),
            color: Colors.white,
            height: size.height * 0.1,
            child: TextField(
              style: const TextStyle(color: colors.brown),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: pale_colors.blue, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: pale_colors.blue, width: 2.0)),
                hintText: "E-mail",
                labelText: "E-mail",
                labelStyle: TextStyle(color: colors.brown),
              ),
              controller: userController,
              onChanged: (value) {},
            ),
          );
        });
  }



Widget passwordTextField(Size size) {
  return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.13),
          height: size.height * 0.1,
          color: Colors.white,
          child: TextField(
            style: const TextStyle(color: colors.brown),
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: const InputDecoration(
              //prefix: Icon(Icons.lock),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: pale_colors.blue, width: 2.0)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: pale_colors.blue, width: 2.0)),
              hintText: "Password",
              labelText: "Password",
              //hintStyle: TextStyle(color: Colores.fondoClaro),
              labelStyle: TextStyle(color: colors.brown),
              // iconColor: Colors.red,
            ),
            controller: passController,
            onChanged: (value) {},
          ),
        );
      });
}


Future<void> login(user, pass, AnswerProvider provider) async {
    if (user.isEmpty || pass.isEmpty){
      setState(() {
        error = true;
      });
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user,
          password: pass,
        );
        setState(() {
          error = false;
        });
        var credential = FirebaseAuth.instance.currentUser;
        if (credential!.emailVerified) {
          final doc = FirebaseFirestore.instance.collection('user-coins').doc(
              credential!.email);
          doc.get().then((value) {
            provider.rewardScore = value['coins'];
          });
          GetStorage().write('email', credential!.email);
          GlobalVars.email = credential!.email!;
          if (keep) {
            GetStorage().write('keep', true);
          }
          else{
            GetStorage().write('keep', false);
          }
          showInsterstitialAd();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chat2Page()),
          );
        }
        else{
          setState(() {
            error = true;
          });
          _showErrorDialog();
        }
      }
      on Exception catch (e) {
        //_showErrorDialog();
        setState(() {
          error = true;
        });
      }
    }
}




  void _showErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            title: Text('ERROR!', style: TextStyle(color: colors.brown, fontWeight: FontWeight.bold, fontSize: 25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/email_verification.png", width: 200,),
                Text('You need to verify your email.',style: TextStyle(color: colors.brown, fontSize: 20)),
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
